Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbYKSVct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbYKSVct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYKSVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:32:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYKSVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:32:40 -0500
Date: Wed, 19 Nov 2008 16:32:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Matt Fleming <matthew.fleming@imgtec.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/9] ftrace: align __mcount_loc sections
In-Reply-To: <20081119212333.052756846@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811191631040.20272@gandalf.stny.rr.com>
References: <20081119212204.318400312@goodmis.org> <20081119212333.052756846@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I need to change my scripts to parse out the first line of all patches, so 
quilt can send out the proper owner. This patch has the following header:

>From 626f82959cd00ca804b12543cad86714e74264da Mon Sep 17 00:00:00 2001
From: Matt Fleming <matthew.fleming@imgtec.com>
Date: Fri, 7 Nov 2008 13:26:25 +0000
Subject: [PATCH] ftrace: align __mcount_loc sections


If you pull from my repo, it will all work out. But still, I do not want 
to take credit for someone else's work.

-- Steve



