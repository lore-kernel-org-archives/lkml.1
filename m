Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbYG1RjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbYG1RjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759474AbYG1RjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:39:07 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:32832 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYG1RjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:39:06 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, eric@anholt.net
Subject: pci_read_base patch series
Date: Mon, 28 Jul 2008 13:38:58 -0400
Message-Id: <1217266741-26519-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jesse,

Could I get you to review this patch series?  I think factoring the code
out of pci_read_bases is a worthwhile thing to do all by itself (and
honestly I've been wanting to do it for a while).  When Eric came up
with a reason to spend a little bit of time on it, I was overjoyed.
He'll be posting his patches that use the new interface later today.

