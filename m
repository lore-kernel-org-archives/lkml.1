Return-Path: <linux-kernel-owner+w=401wt.eu-S965001AbXBLQ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001AbXBLQ7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbXBLQ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:58:25 -0500
Received: from dsl3-63-249-91-56.cruzio.com ([63.249.91.56]:45014 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964987AbXBLQ6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:58:01 -0500
Date: Mon, 12 Feb 2007 08:57:27 -0800
From: Andrew Burgess <aab@cichlid.com>
Message-Id: <200702121657.l1CGvRh5010463@cichlid.com>
To: av1474@comtv.ru, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:
>
> How does the kernel calculates the value it places in `/proc/stat' at
> 4th position (i.e. "idle: twiddling thumbs")?
>
..
>
> Later small kernel module was developed that tried to time how much
> time is spent in the idle handler inside the kernel and exported this
> information to the user-space. The results were consistent with our
> expectations and the output of the test utility.
..
> http://www.boblycat.org/~malc/apc

Vassili

Could you rewrite this code as a kernel patch for
discussion/inclusion in mainline? I and maybe others would
appreciate having idle statistics be more accurate.

Thanks for your work
Andrew

