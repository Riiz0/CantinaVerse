'use client';
import Image from 'next/image';

export function TopSeller() {
    return (
      <section className="section top-seller" id="top-seller">
        <div className="container">

          <p className="section-subtitle">Creative Artist</p>

          <h2 className="h2 section-title">Top Sellers</h2>

          <ul className="grid-list">

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-1.jpg" width="64" height="64" loading="lazy" alt="Richard" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@Richard</a>
                  </h3>

                  <data value="1.5">1.5 BNB</data>
                </div>

              </div>
            </li>

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-2.jpg" width="64" height="64" loading="lazy" alt="John Deo" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@JohnDeo</a>
                  </h3>

                  <data value="2.3">2.3 BNB</data>
                </div>

              </div>
            </li>

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-3.jpg" width="64" height="64" loading="lazy" alt="Junaid" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@Junaid</a>
                  </h3>

                  <data value="2.5">2.5 BNB</data>
                </div>

              </div>
            </li>

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-4.jpg" width="64" height="64" loading="lazy" alt="Yasmin" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@Yasmin</a>
                  </h3>

                  <data value="1.9">1.9 BNB</data>
                </div>

              </div>
            </li>

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-5.jpg" width="64" height="64" loading="lazy" alt="Arham H" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@ArhamH</a>
                  </h3>

                  <data value="3.2">3.2 BNB</data>
                </div>

              </div>
            </li>

            <li>
              <div className="card top-seller-card">

                <figure className="card-avatar">
                  <a href="#">
                    <Image src="/assets/avatar-6.jpg" width="64" height="64" loading="lazy" alt="Sara" />
                  </a>
                </figure>

                <div>
                  <h3 className="card-title">
                    <a href="#">@Sara</a>
                  </h3>

                  <data value="4.7">4.7 BNB</data>
                </div>

              </div>
            </li>

          </ul>
        </div>
      </section>
    );
  }