Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615Ab0BZJDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:03:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38492 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935605Ab0BZJDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:03:40 -0500
Date: Fri, 26 Feb 2010 10:03:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT] trivial fix to REMINDER block in init/main.c
Message-ID: <20100226090333.GA3088@pengutronix.de>
References: <20100225163923.3621094e@torg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225163923.3621094e@torg>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 25, 2010 at 04:39:23PM -0600, Clark Williams wrote:
> Thomas,
> 
> Here's a trivial patch to the RT tree. I noticed during testing that I
> was getting an empty REMINDER block in dmesg. Looks like STACK_TRACER
> got dropped.

This patch doesn't qualify for a patent:

http://marc.info/?l=linux-rt-users&m=123839719221161&w=2

:-)  (IIRC I reordered the tests to have the same order as in the #if,
but didn't recheck.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
