Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYCLWMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYCLWMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYCLWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:12:45 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:45297 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYCLWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:12:44 -0400
Date: Wed, 12 Mar 2008 23:12:38 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
In-Reply-To: <200803110014.52985.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.00.0803122303430.5088@sheep.housecafe.de>
References: <200803110014.52985.rjw@sisk.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10191
> Subject		: Treason uncloaked spams syslog with latest git
> Submitter	: Thomas Gleixner <tglx@linutronix.de>
> Date		: 2008-03-06 05:47
> References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/2444.html

Dunno if you got this, but this seems to be fixed: 
http://lkml.org/lkml/2008/3/11/435

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2008-03-07 21:32
> References	: http://lkml.org/lkml/2008/3/7/308
> 		  http://lkml.org/lkml/2008/3/9/186
> Handled-By	: David Chinner <dgc@sgi.com>

FWIW, it has been reported by Chr too: http://lkml.org/lkml/2008/3/12/313
And David could be taken out of the loop, as it seems dm-crypt related 
(dm-devel@redhat.com is already notified), not XFS related.


Thanks for maintaining this list,
Christian.
-- 
BOFH excuse #348:

We're on Token Ring, and it looks like the token got loose.
