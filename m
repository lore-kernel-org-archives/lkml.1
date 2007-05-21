Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbXEUEuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbXEUEuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXEUEtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:49:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXEUEtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:49:53 -0400
Message-ID: <465124EA.1020801@zytor.com>
Date: Sun, 20 May 2007 21:49:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: young dave <hidave.darkstar@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>	 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>	 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>	 <464DDA40.6010101@zytor.com> <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
In-Reply-To: <a8e1da0705201753i1527138ape2163817c6c0d3b5@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

young dave wrote:
> Hi,
> My cpu is Intel(R) Pentium(R) D CPU 2.80GHz, below are the lspci
> output and kernel

Could you please try booting with "vga=ask", and see if you get the
video mode selection menu?

	-hpa
