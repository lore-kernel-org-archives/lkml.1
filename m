Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXJXLO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXJXLO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXJXLOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:37 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:38991 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbXJXLOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:36 -0400
Message-Id: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/5] fuse fixes for 2.6.24
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are mostly fixes, there's one small cleanup and a protocol
update, that should go with rest of the protocol changes in the
previous submission.

Thanks,
Miklos
--
