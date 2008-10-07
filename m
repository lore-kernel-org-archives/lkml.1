Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYJGLLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYJGLLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYJGLLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:11:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42089 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYJGLLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:11:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add a reference to paper to SubmittingPatches
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org
In-Reply-To: <20081007101728.GA25620@basil.nowhere.org>
References: <20081007101728.GA25620@basil.nowhere.org>
Message-Id: <20081007200932.5A6E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  7 Oct 2008 20:11:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a reference to paper to SubmittingPatches
> 
> For this year's OLS I wrote a paper on successfull strategies
> to submit difficult kernel patches. Add a reference to it to
> SubmittingPatches.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Index: linux-2.6.27-rc4-misc/Documentation/SubmittingPatches
> ===================================================================
> --- linux-2.6.27-rc4-misc.orig/Documentation/SubmittingPatches
> +++ linux-2.6.27-rc4-misc/Documentation/SubmittingPatches
> @@ -672,4 +672,9 @@ Kernel Documentation/CodingStyle:
>  
>  Linus Torvalds's mail on the canonical patch format:
>    <http://lkml.org/lkml/2005/4/7/183>
> +
> +Andi Kleen, "On submitting kernel patches"
> +  Some strategies to get difficult or controversal changes in.
> +  http://halobates.de/on-submitting-patches.pdf
> +

Sure.
here is really good documentation, imo.

ack.



