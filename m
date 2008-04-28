Return-Path: <linux-kernel-owner+w=401wt.eu-S935962AbYD1RuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935962AbYD1RuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934238AbYD1Rt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:49:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:37423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934223AbYD1Rt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:49:57 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/Mi+dIPnHMRxArY9CA5DxNCOkHjmmtdZAijMt7Yl
	o3EpfpnnVAQ6wS
Date: Mon, 28 Apr 2008 19:50:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make mt9{m001,v022}_controls[] static
In-Reply-To: <20080428153930.GO2813@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804281947090.10718@axis700.grange>
References: <20080428153930.GO2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Adrian Bunk wrote:

> This patch makes the needlessly global mt9{m001,v022}_controls[] static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

FWIW, Mauro, you can pull this patch from

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

Thanks
Guennadi
---
Guennadi Liakhovetski
