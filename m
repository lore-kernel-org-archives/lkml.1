Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZCLOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZCLOeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZCLOdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:33:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40000 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZCLOdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:33:50 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: [PATCH 0/7] Per-bdi writeback flusher threads
Date: Thu, 12 Mar 2009 15:33:41 +0100
Message-Id: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is something I've wanted to play with for a while, and I finally
got it hacked up a few days ago. Consider it a playground for writeback
performance/behaviour testing :-)

There's a full description in the next few patches. They are against
current -git.

-- 
Jens Axboe

