Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYJOQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYJOQxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYJOQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:53:07 -0400
Received: from gw.goop.org ([64.81.55.164]:57812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYJOQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:53:04 -0400
Message-ID: <48F61FEB.3020705@goop.org>
Date: Wed, 15 Oct 2008 09:52:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "Roedel, Joerg" <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Tony Luck <tony.luck@intel.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] swiotlb: create appropriate common header for swiotlb
References: <48F55097.4070802@goop.org> <20081015090213.GA14038@amd.com>
In-Reply-To: <20081015090213.GA14038@amd.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roedel, Joerg wrote:
> I did a similar patchset 2 months ago. It should be in the -mm tree.
>
> See http://lkml.org/lkml/2008/8/7/130
>   

Oh, great!  I was worried that I may have broken ia64 or other 
architectures, but you've got a pre-tested fix.

Is it held up on anything?  Is there any reason it isn't in mainline yet?

Thanks,
    J
