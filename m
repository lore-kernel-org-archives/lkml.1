Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYGKJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYGKJLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYGKJKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:10:46 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:24866 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYGKJKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:10:45 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-37.messagelabs.com!1215767443!3565730!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] uio_pdrv updates
Date: Fri, 11 Jul 2008 11:10:35 +0200
Message-ID: <1215767437-20583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
References: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Jul 2008 09:10:37.0502 (UTC) FILETIME=[FBA97DE0:01C8E335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have the following updates to the uio_pdrv driver currently in Greg's
queue:

Uwe Kleine-König (2):
      uio_pdrv: fix memory leak
      uio_pdrv: fix license specification

 drivers/uio/uio_pdrv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

I send them as a reply to this mail.

I already sent the two in a single patch.  The squashed patch was
Acked-by: Hans, so I added his Acked-by: to both patches.

Actually I don't care if they go in as one or two changesets or if they
are both squashed onto the original patch.  Do whatever is easier for
you.

Best regards
Uwe
