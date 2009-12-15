Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbZLOTKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbZLOTKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760938AbZLOTKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:10:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58400 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760927AbZLOTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:10:47 -0500
Date: Tue, 15 Dec 2009 19:10:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: wm831x_reg_read() failure unnoticed in
	wm831x_aldo_get_mode()
Message-ID: <20091215191045.GB21588@opensource.wolfsonmicro.com>
References: <4B27DE73.6060909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27DE73.6060909@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:07:31PM +0100, Roel Kluin wrote:
> ret should be signed to notice a failure in wm831x_reg_read().
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
