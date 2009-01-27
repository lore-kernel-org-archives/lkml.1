Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZA0Ubf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZA0Ubf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZA0UbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:31:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40998 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZA0UbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:31:06 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: linux-kernel@vger.kernel.org
Subject: fsfuzzer 0.7 released
Date: Tue, 27 Jan 2009 15:31:00 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200901271531.00666.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Its been a couple years since I released a new copy of the fsfuzzer program. 
During that time I rewrote the test driver from shell script to "C" so that I 
can exercise exact syscalls. The number of file systems supported has been 
increased. They are: cramfs, ext2/3/4, gfs2, iso9660, jffs2, msdos, reiserfs, 
romfs, squashfs, swap, vfat, xfs, and ecryptfs over other file systems.

The latest release can be found here:

http://people.redhat.com/sgrubb/files/fsfuzzer-0.7.tar.gz

If you have any bug reports or patches, please send them my way.

-Steve
