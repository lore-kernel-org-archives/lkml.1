Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXBEMO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXBEMO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXBEMO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:14:58 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:13681 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173AbXBEMO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:14:57 -0500
X-BigFish: VP
X-FB-SS: 0
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Mon, 5 Feb 2007 13:14:30 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG at mm/slab.c:595
Message-ID: <20070205121430.GH8804@amd.com>
References: <003801c7486c$7d862680$0100a8c0@sslabmayasky>
MIME-Version: 1.0
In-Reply-To: <003801c7486c$7d862680$0100a8c0@sslabmayasky>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Feb 2007 12:14:34.0079 (UTC)
 FILETIME=[3257FEF0:01C7491F]
X-WSS-ID: 69D9C0271WC6054855-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 10:55:19PM +0800, Yu-Chen Wu wrote:
> Hi all,
> 
>            I am developing my module, but meet a bug. Is the bug created by
> me??
> 
>            Kernel:2.6.18  on SUSE10.1 + Intel DualCore
> 

Have you tried that with a vanilla kernel? There is a Debian
bugreport[1] with about a similar issue. But I didn't care about it yet
because it was never reported for vanilla kernels. Seeing your module
source will help anyway.

Joerg

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=406477


-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


