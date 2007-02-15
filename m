Return-Path: <linux-kernel-owner+w=401wt.eu-S965887AbXBOLYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887AbXBOLYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXBOLYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:24:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44838 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965887AbXBOLYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:24:24 -0500
Date: Thu, 15 Feb 2007 11:24:06 +0000 (GMT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Mauro Carvalho Chehab <mchehab@linuxtv.org>,
       Linus Torvalds <torvalds@osdl.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 000/196] V4L/DVB updates
In-Reply-To: <20070215095627.GD11613@zakalwe.fi>
Message-ID: <Pine.LNX.4.64.0702151117490.16819@pentafluge.infradead.org>
References: <1171519195.6703.25.camel@areia> <20070215095627.GD11613@zakalwe.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Heikki Orsila wrote:

> On Thu, Feb 15, 2007 at 03:59:55AM -0200, Mauro Carvalho Chehab wrote:
>> Basically, this series adds support for a bunch of newer cards and newer
>> drivers, do some relevant cleanups on cx88 (improving source code
>> readability and reducing binary code size), adds FM radio support on
>> pvrusb2 and do several other fixes and improvements.
>>
>> A more detailed log:
>>
>> [removed 100+ lines of stuff]
>>>
>> PS.: Due to the size of this series, I'm not mailbombing them into LKML.
>>
>> V4L/DVB development is hosted at http://linuxtv.org
>
> Why weren't these submitted in smaller batches? Why were all these
> patches held back before releasing any?
All those patches are meant to 2.6.21, since they are mostly 
improvements, and are being pushed, from time to time, into -mm series, 
during -rc cycle.

It should also be noticed that they are discussed on subsystem mailing 
lists.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
