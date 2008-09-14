Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYINSxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYINSxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 14:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYINSxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 14:53:39 -0400
Received: from main.gmane.org ([80.91.229.2]:35993 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYINSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 14:53:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: XFS does not recognise mount options in 2.6.27-rc6
Date: Sun, 14 Sep 2008 18:53:21 +0000 (UTC)
Message-ID: <pan.2008.09.14.18.53.20@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
others. Because of this, at boot time it fails to mount the partitions rw, 
making the system unusable.

Some time ago, it seems a patch was about to be committed, but apparently 
this has not been done yet:
http://lkml.org/lkml/2008/8/14/340

What's the status of this now?

-- 
Frederik Himpe

