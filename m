Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZGVLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZGVLyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZGVLyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:54:35 -0400
Received: from mx16.lb01.inode.at ([62.99.145.18]:42947 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752295AbZGVLye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:54:34 -0400
Message-ID: <62.47.75.132.1248263672.wm@webmail.inode.at>
Date: Wed, 22 Jul 2009 13:54:32 +0200 (CEST)
Subject: RE:WARNING: at fs/inode.c:362 invalidate_inodes tainting kernel while trying to mount cifs filesystem
From: "Gerhard Hintermayer" <g.hintermayer@inode.at>
To: <linux-kernel@vger.kernel.org>
X-Priority: 3
Importance: Normal
Reply-To: g.hintermayer@inode.at
X-Mailer: SquirrelMail (version 1.2.8)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to bother you, was my fault.
Unfortunately under kernel 2.6.19 it was possible to mount cifs
filesystems without mount.cifs executable, just with normal mount command,
but under recent kernels this produces an tainted kernel with my posted
error message when not using mount.cifs - strange.

-- 
Gerhard Hintermayer
mailto:g.hintermayer@inode.at



