Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYJ2Qck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYJ2Qck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYJ2Qcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:32:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:31146 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYJ2Qcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ebzPy6RNGrjEvNPMjoXX1lxeMbMSweegT/av2ILFMNilULhYiQKzavt+KnYfRKvvwf
         bb7GOwB6VjzLJRoZebVJp8RhTBKbw2Vy/U66nhLtTxpLCpu5Gy6JFGpRcHzIyRZsb04Y
         AWB1/My1o+wk9JytD99p2zrNgeDGmrOGur8fQ=
From: Jike Song <albcamus@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix inline assembly constraints
Date: Thu, 30 Oct 2008 00:32:16 +0800
Message-Id: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


