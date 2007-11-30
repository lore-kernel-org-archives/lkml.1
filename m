Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXK3SrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXK3SrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbXK3SrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:47:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39686 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761671AbXK3SrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:47:04 -0500
Date: Fri, 30 Nov 2007 10:47:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130183512.GA8985@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301043380.1919@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
 <20071130180002.GB19571@elte.hu> <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
 <20071130183512.GA8985@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> if you treat testing and review efforts like that they might have to 
> wait even longer :-( "My stuff is there somewhere amongst 1415 -mm 
> patches. Thank you for your interest and buzz off already."

Well I guess you have to get used to maintainership I think. F.e. the 
s390 people tested this patchset without requiring a backport. 
Typically arch maintainers test mm and do not force the patches back into 
mainline. I am a bit surprised since Andi and I never had this issue.

