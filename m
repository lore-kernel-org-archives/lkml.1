Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXJLShR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXJLShR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbXJLShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:37:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36885 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXJLShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:37:01 -0400
Message-ID: <470FBEC6.6080109@garzik.org>
Date: Fri, 12 Oct 2007 14:36:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHes] ISDN simple cleanups - hotplug API prep
References: <20071011190655.GA23206@havoc.gtf.org> <20071012161223.GA31078@pingi.kke.suse.de>
In-Reply-To: <20071012161223.GA31078@pingi.kke.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> On Thu, Oct 11, 2007 at 03:06:55PM -0400, Jeff Garzik wrote:
>> Karsten,
>>
>> As I mentioned in previous emails, I would like to send these upstream
>> for 2.6.24.  These are the first step in converting the hisax driver
>> over to the modular, hotplug-friendly ISA/PNP/PCI APIs.
>>
>> The second step in that conversion is 95% complete (one more driver),
>> and is stored in branch 'isdn-pci' of the repository below.
>>
>> The changes below were posted as patches many weeks ago, without
>> comment.  I also propagated these to the 'ALL' branch that gets copied
>> into -mm for testing, though some changes have been there longer than
>> others.
>>
>> All these changes are code movement changes, without any changes to the
>> logic -- even the existing whitespace funnies were kept in many cases.
>>
>> Would you mind pulling these, or permitting me to push them upstream?
>>
> 
> Tested and Acked.

Thanks (for this, and hysdn)

	Jeff



