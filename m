Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXG0SHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXG0SHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXG0SHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:07:32 -0400
Received: from mta-a2.tc.umn.edu ([134.84.119.206]:49302 "EHLO
	mta-a2.tc.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbXG0SHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:07:32 -0400
X-Umn-Remote-Mta: [N] wm1.tc.umn.edu [134.84.119.117] #+LO+NM+TR
From: beck0778@umn.edu
To: linux-kernel@vger.kernel.org
Subject: How to register block device as read-only
Date: 27 Jul 2007 13:07:31 -0500
X-Mailer: Prayer v1.0.16
X-Originating-IP: [160.94.17.169]
Message-ID: <Prayer.1.0.16.0707271307310.28071@wm1.tc.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In a block device driver, how do you tell the kernel that your block device 
is read-only? Is it in the registration of the gendisk, or is there an 
ioctl I should be catching to inform the kernel (and user) that this disk 
is read-only?

--Matthew
