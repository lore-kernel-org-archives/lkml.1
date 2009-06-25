Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFYI45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFYI45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZFYI4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:56:48 -0400
Received: from legaljet.webserversystems.com ([67.18.134.218]:52488 "EHLO
	compulab.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZFYI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:56:47 -0400
Message-ID: <4A433BCD.2030506@compulab.co.il>
Date: Thu, 25 Jun 2009 11:56:45 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Alain Knaff <alain@knaff.lu>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
References: <4A428AFF.20307@free-electrons.com>
In-Reply-To: <4A428AFF.20307@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Michael Opdenacker wrote:
> Hi Alain,
> 
> I would like to test bzip2 and lzma compression on ARM.
> 
> Would you mind telling me what the status of your patches on ARM is, now
> that the x86  and architecture independent code has been merged? Have
> you or has anyone already updated them for 2.6.30, or shall I update
> them by myself?

I'm not sure what exactly do you mean by "test bzip2 and lzma compression on
ARM", but if you refer to internal initramfs compression, I can tell that I've
used lzma compression on PXA270 and it works fine.

> Thank you in advance,
> 
> Cheers,
> 
> Michael.
> 

-- 
Sincerely yours,
Mike.

