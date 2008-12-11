Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYLKKNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYLKKNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYLKKNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:13:13 -0500
Received: from mx1.melware.net ([78.47.171.162]:40324 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbYLKKNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:13:13 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 05:13:13 EST
Date: Thu, 11 Dec 2008 10:48:20 +0100 (CET)
From: Armin Schindler <armin@melware.de>
To: Roel Kluin <roel.kluin@gmail.com>
cc: kkeil@suse.de, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/33] isdn: Make static
In-Reply-To: <493EBDEC.8000202@gmail.com>
Message-ID: <alpine.DEB.0.99.0812111047001.8352@k10.melware.de>
References: <493EA286.7080500@gmail.com> <493EBDEC.8000202@gmail.com>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Roel Kluin wrote:
> Sparse asked whether these could be static.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Armin Schindler <armin@melware.de>

> ---
> drivers/isdn/hardware/eicon/di.c       |    4 +-
> drivers/isdn/hardware/eicon/message.c  |   67 ++++++++++++++++---------------


