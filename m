Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYCZJ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYCZJ7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYCZJ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:59:29 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14776 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753136AbYCZJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:59:28 -0400
Message-ID: <47EA1E53.5070907@panasas.com>
Date: Wed, 26 Mar 2008 11:58:43 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Freemyer <greg.freemyer@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <1206458278.3273.5.camel@localhost.localdomain> <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com> <20080325105228.26396685.randy.dunlap@oracle.com> <20080325180910.GF16721@parisc-linux.org>
In-Reply-To: <20080325180910.GF16721@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 09:58:47.0270 (UTC) FILETIME=[FBE5D860:01C88F27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25 2008 at 20:09 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Mar 25, 2008 at 10:52:28AM -0700, Randy Dunlap wrote:
>>> I'm not sure what the Linux Kernel support is for GPTs.
>> It's implemented.  Not sure about how well used/tested it is.
> 
> ia64 uses it exclusively ... at least on discs that you want to use from
> EFI.
> 
I thinks intel-Macs do too.

Boaz

