Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZC1RuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZC1RuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZC1Rts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:49:48 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:59257 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZC1Rts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:49:48 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Bluetooth: clean ups to l2cap
Date: Sat, 28 Mar 2009 14:47:25 -0300
Message-Id: <1238262449-3321-1-git-send-email-gustavo@las.ic.unicamp.br>
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

Regards.


