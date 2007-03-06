Return-Path: <linux-kernel-owner+w=401wt.eu-S1751390AbXCFUdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbXCFUdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXCFUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:33:42 -0500
Received: from shards.monkeyblade.net ([192.83.249.58]:50870 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXCFUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:33:41 -0500
X-Greylist: delayed 2515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 15:33:41 EST
Subject: [KORG] Zeus1 Downtime
From: "J.H." <warthog9@kernel.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 06 Mar 2007 11:51:45 -0800
Message-Id: <1173210705.15549.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a heads up to everyone,

Zeus1 (one of the frontend machines) will be offline for an extended
period starting late on March 6th, 2007 (PST).  This is to make some
array changes (moving from raid5 to raid6) and to flip the file system
on the mirrors to xfs.  There is no ETA on when zeus1 will come back up
as it will need to resync the entire mirrors after the changes.  Zeus2
will still be online and serving all of the public kernel.org traffic in
the interim, so please be kind to it.

If you have any questions, comments or concerns please don't hesitate to
get ahold of me.

- John 'Warthog9' Hawley
Kernel.org Admin

