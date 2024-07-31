'use client';

import { useState } from 'react'
import { abi } from '../../../lib/abi/FactoryNFTContractABI';
import { useWriteContract } from 'wagmi';
import Header from '@/components/pagesHeader';

export default function Create() {
  return (
    <Header />
  )
}