Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbYJRPvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbYJRPvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYJRPu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:50:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:60314 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYJRPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=dzvSnR6gKfmt1wU78tvadgR8y3n2kvAoZBlb92ALDlrf4X2Dz7M0JVq54sJ5emmGG6
         aYkVBZW4ENO0U2JfZsSSmxWtqWZ1/248GByYmKvpkNASoUp6mhuxWx1Uwatx2f42A5LL
         K6zxjtJPqISgq2bMOwiK5gZnKel7gUrt/LYnQ=
Date: Sat, 18 Oct 2008 17:50:42 +0200
From: Diego Calleja <diegocg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: git.kernel.org feed problems
Message-ID: <20081018175042.4ee5e372@diego-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feed system on git.kernel.org seems to be broken. Check:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=rss
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=atom

The last entry on the atom feed is from 10 September, the rss feed seems to
work fine.
