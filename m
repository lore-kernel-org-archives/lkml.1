Return-Path: <linux-kernel-owner+w=401wt.eu-S937393AbYBWI3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937393AbYBWI3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936749AbYBWITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:19:20 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:40294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935944AbYBWITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N+l2GVHUzJHle9nsSnlouByvGOvkUCf0ql1X1lE/eAJ4Xdtvq5tqo1HyLPGXq5sRNw5T+wZwLQbMXQun2Db6FQmXezTqSvaw4wMC0nSwdq/18gCYognni4P4eq4fsgfAvitpgt2RL1exHwV6IC42c4l97TBSvDfYnpuwIHOcIUc=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 00/16] (Resend) Use get_personality()
Date: Sat, 23 Feb 2008 16:14:03 +0800
Message-Id: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes the macro get_personality function alike
and teaches code to use get_personality() instead of explicit
reference.

[I am sorry if you've received multiple copied of this, since
 my git-send-email doesn't work well. ]

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


