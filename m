Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYICApB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYICApB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYICAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:44:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:43911 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYICAov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:44:51 -0400
Date: Wed, 3 Sep 2008 09:44:45 +0900
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide/Kconfig: mark ide-scsi as deprecated
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200808192111.45351.bzolnier@gmail.com>
References: <200808192111.45351.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080903094402G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 21:11:44 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> Mark ide-scsi as deprecated and remove stale/bogus documentation.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/Kconfig |   16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)

Can we add ide-scsi to Documentation/feature-removal-schedule.txt?
