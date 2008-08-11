Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYHKT4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYHKT4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYHKT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:56:08 -0400
Received: from gw.goop.org ([64.81.55.164]:59162 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYHKT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:56:07 -0400
Message-ID: <48A09942.3060109@goop.org>
Date: Mon, 11 Aug 2008 12:55:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, Cliff Wickman <cpw@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [PATCH] x86_64:  (NEW) Dynamically allocate arch specific	system
 vectors
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080811195102.GL12788@elte.hu>
In-Reply-To: <20080811195102.GL12788@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm very interested in it, even if it's incomplete and wont build/boot 
> at all. So please consider posting your existing incomplete series as an 
> RFC right now, maybe we can help finish it sooner than you will find the 
> time? We can put it into a new tip/x86/irq-unification branch, without 
> merging it into tip/master just yet.

Seconded.  This is the area which most concerns me wrt Xen dom0 
integration, and getting it right should make the Xen-specific parts 
turn out as minor adjuncts.

    J
