Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYE0RZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYE0RZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYE0RZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:25:49 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35050 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbYE0RZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:25:48 -0400
Date: Tue, 27 May 2008 20:25:43 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: PPC PReP link failure - copy_page, empty_zero_page
Message-ID: <Pine.SOC.4.64.0805272022260.869@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling the current kernel on prep ppc:

  MODPOST 703 modules
ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!

-- 
Meelis Roos (mroos@linux.ee)
