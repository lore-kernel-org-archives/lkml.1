Return-Path: <linux-kernel-owner+w=401wt.eu-S1764208AbYGABpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764208AbYGABpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYGABpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:45:31 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42440 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbYGABpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:45:30 -0400
Subject: Re: [PATCH 1/5 V2] MMC: core - fix the use of hard coded timeout
	value.
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org,
       Benzi Zbit <Benzi.Zbit@intel.com>
In-Reply-To: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:45:42 +0200
Message-Id: <1214876742.11537.88.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

> This adds reading and using of enable_timeout from the CIS
> 
> Signed-off-by: Benzi Zbit <Benzi.Zbit@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

looks good.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


