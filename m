Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbXHBQ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbXHBQ7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbXHBQ7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:59:17 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:63081 "EHLO
	outbound6-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbXHBQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:59:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 2 Aug 2007 11:00:39 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, tiwai@suse.de, rafalbilski@interia.pl
Subject: Re: CS5530 Alsa driver fails
Message-ID: <20070802170039.GB27319@cosmic.amd.com>
References: <20070802135700.09319306@the-village.bc.nu>
 <20070802152319.GA25325@cosmic.amd.com>
 <20070802180122.7b38d222@the-village.bc.nu>
MIME-Version: 1.0
In-Reply-To: <20070802180122.7b38d222@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Aug 2007 16:59:03.0057 (UTC)
 FILETIME=[6DC6D810:01C7D526]
X-WSS-ID: 6AACD2DD7CS3981448-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07 18:01 +0100, Alan Cox wrote:
> > And as an aside, the VSA2 source code is open, so you can peruse
> > it and discover its secrets for yourself:
> > 
> > http://dev.laptop.org/git.do?p=geode-vsa;a=tree;hb=HEAD
> 
> Interesting. I shall have to compare that with the CS5510/20 VSA1 tree I
> have here (which isn't under LGPL)

Not to get any further off topic - but we're still soliciting volunteers
to help port the VSA2 code so that it will build with OSS tools.  If you're
interested, don't hesitate to dive in.  :)  Patches always gladly accepted.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


