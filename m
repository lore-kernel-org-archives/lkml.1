Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZCYTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZCYTP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbZCYTPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:15:13 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:32878 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZCYTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:15:12 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 15:15:12 EDT
Message-ID: <49CA806F.EE0D623D@users.sourceforge.net>
Date: Wed, 25 Mar 2009 21:05:19 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2f file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Work around kernel interface changes in 2.6.29-rc kernels
- Maximum prealloc limit increased to 4096 pages.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2f.tar.bz2
    md5sum 9f309e723bed7614533e24e8a0baa81e

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2f.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
