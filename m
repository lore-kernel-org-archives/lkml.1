Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZKTXqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZKTXqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZKTXqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:46:09 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46337 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKTXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iHIX1XMcLQeDJpMSijL1HZfJno0/BJEoiu33xkseWUSVRtM6xOXZepi59bgG1OXxxh
         LyKIgqDMALjiGhQH46IwScNEJkj8NBgwUtL2GQALxCQ5dosTVKvUqWodiJ/q0+i08sEs
         Ftrb3CBKFwCiXmHmqx5KE9LQz1D54lKk50yEk=
From: Bruce Beare <bbeare1@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH 0/3] checkpatch.pl cleanups for drivers/staging/comedi/drivers/pcmad.c
Date: Fri, 20 Nov 2009 15:46:08 -0800
Message-Id: <1258760771-24311-1-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three patches are included to cleanup
drivers/staging/comedi/drivers/pcmad.c file to eliminate
all errors found by scripts/checkpatch.pl.

Bruce Beare (3):
  Cleanup: code indent warning messages (use tabs instead of leading
    spaces).
  Cleanup: Remove unneeded braces (cleanup warning message)
  cleanup: printk() warnings for including the facility level. cleanup:
    add a printk("\n") to terminate the print for the non-error case.

 drivers/staging/comedi/drivers/pcmad.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

