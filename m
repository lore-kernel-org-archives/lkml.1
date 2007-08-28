Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbXH1TeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbXH1TeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932365AbXH1TYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:24:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58719 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763136AbXH1TYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:24:38 -0400
Date: Tue, 28 Aug 2007 21:25:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: lkml@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/ver_linux : correct printing of binutils version
Message-ID: <20070828192558.GA32202@uranus.ravnborg.org>
References: <200708020121.15883.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708020121.15883.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 01:21:15AM +0200, Jesper Juhl wrote:
> Hi,
> 
> Currently scripts/ver_linux prints "Binutils" or other random 
> information for the version number in the "binutils" output line 
> on some distributions. This patch corrects that.
> 
> When I initially submitted a patch to correct that, I was not aware 
> that the output from "ld -v" could differ as much as it turned out 
> it can, so my original fix turned out to not cover all bases.
> This patch works correctly with all the different "ld -v" output 
> that people posted in replys to my first patch, so it should be a 
> clear win over what we have currently.
> 
> Please apply.

Done,

	Sam
