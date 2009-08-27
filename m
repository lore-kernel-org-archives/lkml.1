Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbZH0JJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbZH0JJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZH0JJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:09:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45798 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZH0JJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:09:00 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: tj@kernel.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       dhowells@redhat.com
Subject: [PATCH 0/3] Convert libata pio task to slow-work
Date: Thu, 27 Aug 2009 11:08:39 +0200
Message-Id: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support for slow-work for delayed slow work and
for cancelling slow work. Note that these patches are totally
untested!

-- 
Jens Axboe

