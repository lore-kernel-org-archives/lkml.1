Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZAUSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZAUSP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZAUSPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:15:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37702 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZAUSPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:15:05 -0500
Message-ID: <497765E6.4030108@garzik.org>
Date: Wed, 21 Jan 2009 13:13:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>,
       open-osd development <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org>	<1231802758.27151.18.camel@localhost.localdomain>	<496C9ABE.8060300@garzik.org>	<20090113140328.3aab5a35@lxorguk.ukuu.org.uk>	<496CA26E.1080708@garzik.org> <20090113161450.2fdd1d5d@lxorguk.ukuu.org.uk> <496CCD9F.2000401@panasas.com>
In-Reply-To: <496CCD9F.2000401@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, where can the latest libosd be found?

I'll want to use that for osdblk (export a single OSD object as a Linux 
block device).

	Jeff




