Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYEMLXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYEMLXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYEMLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:23:04 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:40073 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYEMLXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:23:03 -0400
X-Greylist: delayed 2673 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 07:23:03 EDT
Date: Tue, 13 May 2008 12:38:28 +0200
To: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc2 hosed X?
Message-ID: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I usually follow the -rc series with skipping the -rc1 (waiting for the
worst errors to be fixed).

Here now a severe regression with respect to 2.6.25: X seems to be hosed
in the sense that:
- switching to console
- suspend 2 ram
- suspend 2 disk
often leaves the computer completely unusable.

I am using:
- Debian/sid up2date, i.e. xorg server 7.3
- intel Chipset 945GM (Acer laptop)
- intel xorg video driver 2.2.1 and 2.3.1 (both tested)

Since not even Sysrq is working I cannot get a log file or whatsoever.

Is that something known, are is there some patch to revert/test?

Thanks a lot and all the best

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LUTON (n.)
The horseshoe-shaped rug which goes around a lavatory seat.
			--- Douglas Adams, The Meaning of Liff
