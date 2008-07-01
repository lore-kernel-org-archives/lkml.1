Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbYGABo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbYGABo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYGABoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:44:16 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42429 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbYGABoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:44:16 -0400
Subject: Re: [PATCH 2/5 V2] MMC: wbsd.c fix shadowing of 'dma' variable
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:44:28 +0200
Message-Id: <1214876668.11537.86.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> This patch fix warning :shadowing dma variable
> and made use of module_param_named instead of module_param
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

looks good to me.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


