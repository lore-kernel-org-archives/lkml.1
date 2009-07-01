Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZGAPFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZGAPFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZGAPFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:05:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48013 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZGAPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:05:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A4B7A77.8010208@s5r6.in-berlin.de>
Date: Wed, 01 Jul 2009 17:02:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Julien BLACHE <jb@jblache.org>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, felixb@sgi.com
Subject: Re: [patch 000/108] 2.6.30-stable review
References: <20090701002838.GA7100@kroah.com> <87tz1wd4vi.fsf@sonic.technologeek.org>
In-Reply-To: <87tz1wd4vi.fsf@sonic.technologeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julien BLACHE wrote:
> Felix wrote it was a candidate for stable (obviously!) but it's not on
> the list you posted. Care to include it?

I am routinely astonished by the "please include patch XY" postings. :-)
Have a look at 
http://lxr.linux.no/linux/Documentation/stable_kernel_rules.txt -- this 
explains how you get a patch included with minimum effort by everyone 
involved.  IOW, send the patch¹, not the question.  :-)

¹) if the patch is actually applicable to the kernel and fulfills the 
stable criteria.  If in doubt about the latter, the respective subsystem 
developers might help you figure it out.)
-- 
Stefan Richter
-=====-==--= -=== ----=
http://arcgraph.de/sr/
