Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZDTEeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZDTEeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDTEdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:33:51 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45652 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZDTEdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:33:51 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Bluetooth: l2cap clean ups
Date: Mon, 20 Apr 2009 01:31:04 -0300
Message-Id: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are result of my hackings to l2cap.
First and third just create macros to do not show some number in
code. Also facilite the hacking because we don't need to go to spec
to figure out what that numbers shows. The first patch is a resend.
The last patch is the result of run l2cap files against checkpatch.pl

Regards


