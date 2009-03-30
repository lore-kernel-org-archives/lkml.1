Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZC3GXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZC3GXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZC3GXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:23:30 -0400
Received: from gw.goop.org ([64.81.55.164]:51883 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZC3GXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:23:30 -0400
Message-ID: <49D0655F.8080100@goop.org>
Date: Sun, 29 Mar 2009 23:23:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 updates for v2.6.30, final bits
References: <20090328220307.GA16314@elte.hu>
In-Reply-To: <20090328220307.GA16314@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Linus,
>
> Please pull the latest x86-stage-3-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-stage-3-for-linus
>
> This concludes the x86 merge window.
>   

I'm planning on getting Xen changes into this merge window.   I was 
expecting you to at least take the branches which have an impact on the 
arch/x86 side, but I guess there was a miscommunication there.

However, since all your pending x86 changes are now sent, do you have 
any objections me sending out pull requests for the Xen changes I've 
previously posted?  If not, I'll start tomorrow.

Thanks,
    J
