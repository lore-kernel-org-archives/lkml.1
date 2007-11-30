Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXK3UJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXK3UJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXK3UJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:09:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753062AbXK3UJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:09:30 -0500
Date: Fri, 30 Nov 2007 12:09:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130200641.GA385@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301208300.2369@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
 <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
 <20071130183512.GA8985@elte.hu> <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com>
 <20071130194517.GD9928@elte.hu> <Pine.LNX.4.64.0711301147100.2242@schroedinger.engr.sgi.com>
 <20071130200641.GA385@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> which answers your question: i only pointed out that this is very 
> similar to what i saw, spontaneous reboots. So why did you call this a 
> "side swipe"? I connected up different bugreports. I do not claim that 
> Andrew's reboot was necessarily due to the percpu patches, i just 
> pointed out the similarity of the symptoms.

Ahh. Ok. I was also wrong to assume hostility.
