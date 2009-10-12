Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZJLJfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZJLJfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZJLJe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:34:59 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:51927 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZJLJe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c3WE4TCv8rNgaRa4d3Ar+xulzjKY7tUVg6PdpYjip3tIuI0fIgGWLCP1kZQYDKtb6Z
         0teZCA9cdGCB1UdL/cl6NvFGeGcxcaoQeZKGXBObmLhV3g8kFLe5hGNLtByivxlV6C3U
         P/OTWTsdU3Y6Al18gNXuUPGpb8WvKKa2bm7j0=
Date: Mon, 12 Oct 2009 17:34:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc4
Message-ID: <20091012133418.GB4900@x200>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
 <20091012082950.GA2270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012082950.GA2270@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:29:50AM +0200, Ingo Molnar wrote:
> Alexey, could you please Cc: affected maintainers in the future, so that 
> we can avoid such problems?

And can you merge fallout your compile farm found into single "fallout"
patch. Inflating number of commits doesn't really help.
