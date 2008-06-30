Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbYF3I6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbYF3I6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYF3I54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:57:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41163 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbYF3I5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:57:55 -0400
Subject: Re: [PATCH 1/3] mmc_core: fix the use of hard coded timeout value.
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org,
       Benzi Zbit <Benzi.Zbit@intel.com>
In-Reply-To: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 10:58:05 +0200
Message-Id: <1214816285.11537.24.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

>  drivers/mmc/core/sdio_cis.c   |    2 ++
>  drivers/mmc/core/sdio_io.c    |    7 ++-----
>  include/linux/mmc/sdio_func.h |    1 +
>  3 files changed, 5 insertions(+), 5 deletions(-)
>  mode change 100644 => 100755 drivers/mmc/core/sdio_cis.c
>  mode change 100644 => 100755 drivers/mmc/core/sdio_io.c
>  mode change 100644 => 100755 include/linux/mmc/sdio_func.h

there is something wrong with your setup. Don't change the file modes
and please resent the patch.

Regards

Marcel


