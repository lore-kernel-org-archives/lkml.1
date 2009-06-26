Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbZFZRos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbZFZRos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZFZRok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:44:40 -0400
Received: from mailq1.tnnet.fi ([217.112.240.127]:57832 "EHLO mailq1.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZFZRoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:44:39 -0400
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2009 13:44:38 EDT
Message-ID: <4A450658.4F89D9D5@users.sourceforge.net>
Date: Fri, 26 Jun 2009 20:33:12 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@nl.linux.org
CC: linux-kernel@vger.kernel.org
Subject: Announce loop-AES-v3.2g file/swap crypto package
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-AES changes since previous release:
- Fixed losetup -f bug in ancient util-linux-2.12r patch. This was actually
  a link goof that linked wrong version of a function. Newer util-linux-ng
  version was not affected. Bug reported by Phil Grundig.
- Worked around block layer interface breakage on linux-2.6.31-rc1 kernel.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2g.tar.bz2
    md5sum c54bdd2b01f57fee1a93a5bbbd3ce505

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.2g.tar.bz2.sign

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
