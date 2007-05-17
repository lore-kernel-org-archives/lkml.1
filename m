Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXEQWIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXEQWIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbXEQWIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:08:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36607 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbXEQWIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:08:40 -0400
Date: Fri, 18 May 2007 00:09:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up printing of Linux C Library version in scripts/ver_linux
Message-ID: <20070517220937.GD9069@uranus.ravnborg.org>
References: <200705071344.06068.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705071344.06068.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 01:44:05PM +0200, Jesper Juhl wrote:
> 
> I just noticed, when running scripts/ver_linux on a Gentoo system, that the
> line printing the C library version looked a little odd. So I fixed it up
> to be in line with all the rest.
> 
> Old output:
> Linux C Library        > libc.2.5
> New output:
> Linux C Library        2.5
> 

Thanks, applied.

	Sam
