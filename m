Return-Path: <linux-kernel-owner+w=401wt.eu-S965555AbXCLNY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555AbXCLNY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965569AbXCLNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:24:27 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:12769 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965555AbXCLNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:24:26 -0400
Message-ID: <45F55485.1030603@fr.ibm.com>
Date: Mon, 12 Mar 2007 14:24:21 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312122305.GB107@tv-sign.ru>
In-Reply-To: <20070312122305.GB107@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/12, Rafael J. Wysocki wrote:
>> On Monday, 12 March 2007 09:14, Pavel Machek wrote:
>>> Can we get better name for this function?
>> Well, I took the name from the Oleg's message.  Can you please suggest
>> something?
> 
> Well, kthread_should_stop_check_freeze() is really awful, I agree :)
> We need something better, but I can't suggest anything.

not much better, but what about kthread_should_stop_or_freeze() ?

cheers,

C.
