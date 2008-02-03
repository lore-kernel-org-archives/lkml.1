Return-Path: <linux-kernel-owner+w=401wt.eu-S936464AbYBCKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936464AbYBCKES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 05:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbYBCKEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 05:04:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48682 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694AbYBCKD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 05:03:59 -0500
Date: Sun, 3 Feb 2008 11:04:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: Frans Pop <elendil@planet.nl>, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH try#2 ] kbuild: add svn revision information to setlocalversion
Message-ID: <20080203100403.GA20810@uranus.ravnborg.org>
References: <20080202203503.GA26415@uranus.ravnborg.org> <E1JLPrz-00059X-Sc@faramir.fjphome.nl> <20080202213015.GA27015@uranus.ravnborg.org> <1202019206.6671.18.camel@roc-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202019206.6671.18.camel@roc-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 02:13:26PM +0800, Bryan Wu wrote:
> >From 0a7a2c6f19d32a85ca1a7887382325170ef19a66 Mon Sep 17 00:00:00 2001
> From: Bryan Wu <bryan.wu@analog.com>
> Date: Sun, 3 Feb 2008 14:05:00 +0800
> Subject: [PATCH] [Scripts] add svn revision information to setlocalversion
> 
> follow git and mercurial style, include uncommitted changes detect
> 
> Cc: Frans Pop <elendil@planet.nl>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

Applied and pushed out.
Thanks for the review Frans and thanks for the quick fix Bryan.

	Sam
