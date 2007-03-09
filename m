Return-Path: <linux-kernel-owner+w=401wt.eu-S1767296AbXCIN5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767296AbXCIN5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767298AbXCIN5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:57:49 -0500
Received: from holomorphy.com ([66.93.40.71]:34003 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767296AbXCIN5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:57:48 -0500
Date: Fri, 9 Mar 2007 05:57:51 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Message-ID: <20070309135751.GE2986@holomorphy.com>
References: <200703091625.55361.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703091625.55361.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> I consider policy issues to be hopeless political quagmires and
>> therefore stick to mechanism. So even though I may have started the
>> code in question, I have little or nothing to say about that sort of
>> use for it.
>> There's my longwinded excuse for having originated that tidbit of code.

On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> I've no idea what both of you are talking about.

The short translation of my message for you is "Linus, please don't
LART me too hard."


On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> How can giving people the freedom of choice be in any way counter-productive?

This sort of concern is too subjective for me to have an opinion on it.
My preferred sphere of operation is the Manichean domain of faster vs.
slower, functionality vs. non-functionality, and the like. For me, such
design concerns are like the need for a kernel to format pagetables so
the x86 MMU decodes what was intended, or for a compiler to emit valid
assembly instructions, or for a programmer to write C the compiler
won't reject with parse errors. If Linus, akpm, et al object to the
design, then invalid output was produced. Please refer to Linus, akpm,
et al for these sorts of design concerns.


-- wli
