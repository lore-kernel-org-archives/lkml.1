Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYICLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYICLVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYICLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:21:04 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:29714 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYICLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:21:02 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Wed, 3 Sep 2008 07:20:54 -0400
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <200809021444.17153.linux@sandersweb.net> <1220440179.8609.100.camel@twins>
In-Reply-To: <1220440179.8609.100.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809030720.56719.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 07:09, Peter Zijlstra wrote:
> Yeah - gitk's default fonts are a nightmare, I get a semi readable
> interface by adding this to ~/.gitk
>
> set mainfont {{dejavu sans mono} 10}
> set textfont {{dejavu sans mono} 9}
> set uifont {{dejavu sans mono} 10 bold}
>
> But it seems the tcl/tk font rendering is pretty horrible all-round. I
> generally prefer to use qgit for this reason.
Thanks that is a big improvement.
