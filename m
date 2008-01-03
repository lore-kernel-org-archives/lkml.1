Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYACNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYACNXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYACNW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:22:58 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:20990 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750939AbYACNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:22:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=boRD0YY1taVPHPXfWz34qvG6+owq+PA40xX+xB57iW4tyuuhAOoTnnZAK2ukd9pTau8FZovgAJAyCcBvU4m28z9+e5qdqYvgK7/5dDWtwp63B8mNU6yBqgPqSKTOHySEo8PLmX+LQGKvxqWj65os2dzyXwOHbYLG7Zzwn1UajYw=  ;
X-YMail-OSG: QHf6CaoVM1k1pzB6vs9kByp5wAsM58GmouWjxuzg3asXPQlX
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com
Subject: [RESEND PATCH 0/10] ide-floppy redux p1
Date: Thu,  3 Jan 2008 14:19:59 +0100
Message-Id: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bart,

here's the unfinished redux of ide-floppy which i'm REsending now so that we could
sinchronize trees. The original send got busted in vger's filters due to syntax
error in the Message-ID tag.

 Documentation/ide/ChangeLog.ide-floppy.1996-2002 |   64 ++
 drivers/ide/ide-floppy.c                         | 1248 +++++++---------------
 drivers/ide/ide-floppy.h                         |  351 ++++++
 include/linux/cdrom.h                            |    1 +
 4 files changed, 819 insertions(+), 845 deletions(-)

