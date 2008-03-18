Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYCRNDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYCRNDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 09:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYCRNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 09:02:55 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60809 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbYCRNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 09:02:54 -0400
Message-ID: <47DFBD99.2080501@davidnewall.com>
Date: Tue, 18 Mar 2008 23:33:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <alpine.DEB.1.00.0803170740440.14887@asgard.lang.hm> <alpine.DEB.1.00.0803171021300.17640@asgard.lang.hm> <200803180233.10156.phillips@phunq.net>
In-Reply-To: <200803180233.10156.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> You will need:
>
>   * Two Violin 1010 memory devices
>
>   * Four UPS units each rated for one hour at 600 Watts
>
>   * Two servers, each with at least two 8x PCI-e slots
>
>   * One SAN with a bunch of 15K rpm scsi disks
>   


Honestly, this isn't at all what I understood you to be talking about. 
In your very first post you described ramback as "a new virtual device
with the ability to back a ramdisk by a real disk."  I assumed "ramdisk"
to mean the Linux psuedo-device.  I never understood that you meant an
external device, in fact I thought ramback was *instead of* a Violin. 
Since you're talking about external ram, it survives operating system
crashes and of course that is not such a big deal as I was thinking.
