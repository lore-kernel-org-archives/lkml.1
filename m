Return-Path: <linux-kernel-owner+w=401wt.eu-S967171AbXG3Qfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967171AbXG3Qfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764063AbXG3Qeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:34:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:6001 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966919AbXG3Qe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=NQZ6/K45HVz22EsL3kpHdVg4iiWGCTVEnCQU2VAzNZd2dZ54cBR861cpa3OYKWUWeVH8F3y3QeBRjyJwroZhZ1MfN8bY/FKhhNPkzbLUhlMICd74NU0tk36wjDwVspF4CMSKemsgCd/IVEH3ZHhSbRys7xJM5cWFe4GcS6ZShQs=
Message-ID: <46AE130B.8020005@googlemail.com>
Date: Mon, 30 Jul 2007 18:34:19 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       v4l-dvb-maintainer@linuxtv.org, Thierry MERLE <thierry.merle@free.fr>,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@stusta.de>, Trent Piepho <xyzzy@speakeasy.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [2/3] 2.6.23-rc1: known regressions with patches v3
References: <46AE114F.2010201@googlemail.com>
In-Reply-To: <46AE114F.2010201@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            6
Andi Kleen                             4
Andrew Morton                          4
Linus Torvalds                         4
Al Viro                                3
Jens Axboe                             3
Tejun Heo                              3
David Woodhouse                        2
Hugh Dickins                           2



FS

Subject         : NFSv4 poops itself
References      : http://lkml.org/lkml/2007/7/27/144
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org> 
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/7/27/183
Status          : patch available



Media

Subject         : usbvision: don't return an uninitialized value
References      : http://lkml.org/lkml/2007/7/23/65
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : Thierry MERLE <thierry.merle@free.fr>
                  commit c5f48367fe54c46805774eeea8e828de54a5ad7b
Handled-By      : Trent Piepho <xyzzy@speakeasy.org>
Patch           : http://lkml.org/lkml/2007/7/23/114
Status          : patch available



Memory management

Subject         : [bug] SLUB & freeing locks
References      : http://lkml.org/lkml/2007/7/26/90
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : Peter Zijlstra <peterz@infradead.org>
Patch           : http://lkml.org/lkml/2007/7/26/97
Status          : patch available



SYSFS

Subject         : sysfs/udev broken in 2.6.23-rc1
References      : http://lkml.org/lkml/2007/7/24/276
Last known good : ?
Submitter       : Simon Arlott
Caused-By       : ?
Handled-By      : Kay Sievers <kay.sievers@vrfy.org>
                  Cornelia Huck <cornelia.huck@de.ibm.com>
Patch           : http://lkml.org/lkml/2007/7/25/83
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
