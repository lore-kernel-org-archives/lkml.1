Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXK3RJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXK3RJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935456AbXK3RIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:08:20 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33456 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935451AbXK3RIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:08:18 -0500
Date: Fri, 30 Nov 2007 09:08:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130112645.GA7565@elte.hu>
Message-ID: <Pine.LNX.4.64.0711300905560.32071@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> config below. I'm dropping the patches for now. (again, this might be my 
> mismerge)

These patches are against 2.6.24-rc3-mm2 and require core code changes. 
You cannot simply merge them into the x86 arch.
