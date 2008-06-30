Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYF3Lp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYF3Lp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbYF3LpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:45:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:18250 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbYF3LpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,727,1204531200"; 
   d="scan'208";a="347055519"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 1/3] mmc_core: fix the use of hard coded timeout value.
Date: Mon, 30 Jun 2008 14:45:06 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010415E5D5@hasmsx412.ger.corp.intel.com>
In-Reply-To: <1214816285.11537.24.camel@violet.holtmann.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] mmc_core: fix the use of hard coded timeout value.
Thread-Index: Acjaj3Q6s06VubDjT2GqW8pu+TkR8AAFzrWQ
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com> <1214816285.11537.24.camel@violet.holtmann.net>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Cc: <drzeus-list@drzeus.cx>, <linux-kernel@vger.kernel.org>,
       "Zbit, Benzi" <benzi.zbit@intel.com>
X-OriginalArrivalTime: 30 Jun 2008 11:45:09.0383 (UTC) FILETIME=[BF970170:01C8DAA6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Marcel Holtmann [mailto:marcel@holtmann.org]
>Sent: Monday, June 30, 2008 11:58 AM
>To: Winkler, Tomas
>Cc: drzeus-list@drzeus.cx; linux-kernel@vger.kernel.org; Zbit, Benzi
>Subject: Re: [PATCH 1/3] mmc_core: fix the use of hard coded timeout
value.
>
>Hi Tomas,
>
>>  drivers/mmc/core/sdio_cis.c   |    2 ++
>>  drivers/mmc/core/sdio_io.c    |    7 ++-----
>>  include/linux/mmc/sdio_func.h |    1 +
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>  mode change 100644 => 100755 drivers/mmc/core/sdio_cis.c
>>  mode change 100644 => 100755 drivers/mmc/core/sdio_io.c
>>  mode change 100644 => 100755 include/linux/mmc/sdio_func.h
>
>there is something wrong with your setup. Don't change the file modes
>and please resent the patch.

Oops, missed that.
Thanks
Tomas


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

