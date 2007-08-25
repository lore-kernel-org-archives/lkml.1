Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXHYKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXHYKuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933804AbXHYKuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:50:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48005 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220AbXHYKuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:50:12 -0400
Date: Sat, 25 Aug 2007 12:51:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix export_report.pl
Message-ID: <20070825105102.GA15183@uranus.ravnborg.org>
References: <20070824210451.GE30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824210451.GE30705@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:04:51PM +0200, Adrian Bunk wrote:
> This patch fixes an annoying bug of export_report.pl missing the usages 
> of some exports.
Applied to kbuild.git plus Ram Pai's patch too.

	Sam
