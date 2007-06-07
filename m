Return-Path: <linux-kernel-owner+w=401wt.eu-S1765078AbXFGPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765078AbXFGPp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbXFGPpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:45:07 -0400
Received: from rtr.ca ([64.26.128.89]:1775 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762256AbXFGPpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:45:06 -0400
Message-ID: <466827FF.1030304@rtr.ca>
Date: Thu, 07 Jun 2007 11:45:03 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Bad behaviour after hdparm -M  128
References: <fa.DWgGSeKzniALToNSyX9W5NibA1w@ifi.uio.no> <4666C4B9.8060408@shaw.ca> <20070606154442.GB13166@khazad-dum.debian.net> <20070606162425.GA3943@atjola.homenet> <20070606164854.GA18984@khazad-dum.debian.net> <20070606175112.GA4659@atjola.homenet> <20070606210337.GA31549@khazad-dum.debian.net> <20070606213617.GA6580@atjola.homenet> <20070606215232.GC31549@khazad-dum.debian.net>
In-Reply-To: <20070606215232.GC31549@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Wed, 06 Jun 2007, Björn Steinbrink wrote:
>> HDAPS support is available, revision is MB2IA60A.
> 
> That would usually rule out the possibility of it being the firmware, but we
> have different disks, so different firmware.
> 
> It looks like I will have to try 2.6.22 to know for sure.
> 

"hdparm -I" should list "Automatic Acoustic Management feature set"
(near the bottom) for any drive that *does* support the -M feature.
