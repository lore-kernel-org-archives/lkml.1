Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZGVMrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZGVMrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZGVMrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:47:48 -0400
Received: from mx19.lb01.inode.at ([62.99.145.21]:24174 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754496AbZGVMrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:47:47 -0400
Message-ID: <62.47.75.132.1248266864.wm@webmail.inode.at>
Date: Wed, 22 Jul 2009 14:47:44 +0200 (CEST)
Subject: RE: RE:WARNING: at fs/inode.c:362 invalidate_inodes tainting kernel while trying to mount cifs filesystem
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

Sorry, to bother you again, the problem still persists, mounting is most
of the time not possible, and sometimes it is. Unfortunately reexporting
is still not possible if cifs is compiled with EXPERIMENTAL option. Very
strange.

Please CC me, as I'm not on the list.
-- 
Gerhard Hintermayer
mailto:g.hintermayer@inode.at



