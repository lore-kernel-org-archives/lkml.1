Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbXGLGJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbXGLGJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXGLGJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:09:33 -0400
Received: from gw.goop.org ([64.81.55.164]:44292 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbXGLGJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:09:33 -0400
Message-ID: <4695C564.5060500@goop.org>
Date: Wed, 11 Jul 2007 23:08:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com>
In-Reply-To: <200707111916.35036.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> One of the big problem spots was XFS, but that got some stack usage 
> fixes recently, and the 4K stack option has been around for quite a 
> while now, so people really should have gotten around to fixing any 
> code that can't handle it.   Are there still any big problem areas 
> remaining?
>   

I get frequent crashes when I use 4k stacks with XFS+lvm, using recent 
kernels.  When did XFS stack use reductions go in?

    J
