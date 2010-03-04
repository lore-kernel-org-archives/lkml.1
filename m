Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0CDOfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:35:09 -0500
Received: from lo.gmane.org ([80.91.229.12]:36015 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0CDOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:35:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thorsten Glaser <tg@debian.org>
Subject: Re: [REGRESSION] Can't boot lvm on root (Ubuntu 9.10 userspace) with 2.6.33
Date: Thu, 4 Mar 2010 13:54:58 +0000 (UTC)
Message-ID: <loom.20100304T145423-538@post.gmane.org>
References: <E1Nmppq-0000sA-E1@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 87.139.34.156 (Lynx/2.8.7dev.7 libwww-FM/2.14 SSL-MM/1.4.1 GNUTLS/1.6.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso <at> mit.edu> writes:

> a failed initramfs.   And of course, the initramfs environment is so
> crappy that there are no debugging aids --- not even a working pager.

While not a pager (could probably easily be added), I’ve got patches
for klibc that let an almost full-featured mksh build against it… and
it’s not much bigger (40K or so) than ash.

bye,
//mirabilos
-- 
«MyISAM tables -will- get corrupted eventually. This is a fact of life. »
“mysql is about as much database as ms access” – “MSSQL at least descends
from a database” “it's a rebranded SyBase” “MySQL however was born from a
flatfile and went downhill from there” – “at least jetDB doesn’t claim to
be a database”	(#nosec)    ‣‣‣ Please let MySQL and MariaDB finally die!

