Return-Path: <linux-kernel-owner+w=401wt.eu-S934083AbXHYKuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbXHYKuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 06:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765089AbXHYKuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 06:50:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58068 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765059AbXHYKuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 06:50:04 -0400
Date: Sat, 25 Aug 2007 12:51:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] call export_report from the Makefile
Message-ID: <20070825105122.GB15183@uranus.ravnborg.org>
References: <20070824210456.GF30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824210456.GF30705@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:04:56PM +0200, Adrian Bunk wrote:
> The main feature is that export_report now automatically works
> for O= builds.
Applied to kbuild.git.

	Sam
