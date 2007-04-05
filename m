Return-Path: <linux-kernel-owner+w=401wt.eu-S1161171AbXDEFCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161171AbXDEFCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161179AbXDEFCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:02:55 -0400
Received: from mo31.po.2iij.NET ([210.128.50.54]:4207 "EHLO mo31.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161171AbXDEFCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:02:54 -0400
Message-Id: <200704050502.l3552gss048910@mbox31.po.2iij.net>
Date: Thu, 5 Apr 2007 14:02:42 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: yoichi_yuasa@tripeaks.co.jp, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Cobalt button interface driver support
In-Reply-To: <200704040001.41494.dtor@insightbb.com>
References: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
	<d120d5000702160715x6f64853y59abb8a22e7d164c@mail.gmail.com>
	<20070217012242.6a51f55b.yoichi_yuasa@tripeaks.co.jp>
	<200704040001.41494.dtor@insightbb.com>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 4 Apr 2007 00:01:41 -0400
Dmitry Torokhov <dtor@insightbb.com> wrote:

> Hi Yoichi,
> 
> Could you please try the patch below? It moves platform device creation
> code into cobalt arch code to belletr follow driver model.

It works fine.

Acked-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Yoichi

