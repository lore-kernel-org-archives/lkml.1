Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbXGQMdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbXGQMdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXGQMd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:33:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36915 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbXGQMdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:33:25 -0400
Date: Tue, 17 Jul 2007 14:34:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] Makefile: use -fno-optimize-sibling-calls unconditionally
Message-ID: <20070717123439.GA24780@uranus.ravnborg.org>
References: <20070713041847.GZ3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713041847.GZ3492@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 06:18:47AM +0200, Adrian Bunk wrote:
> We don't have to check for -fno-optimize-sibling-calls since even
> gcc 3.2 supports it.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied,

	Sam
