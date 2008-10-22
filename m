Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYJVQUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYJVQUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYJVQUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:20:41 -0400
Received: from exhub016-2.exch016.msoutlookonline.net ([207.5.72.164]:48568
	"EHLO EXHUB016-2.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbYJVQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:20:41 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 12:20:40 EDT
Message-ID: <48FF506F.6060701@cfl.rr.com>
Date: Wed, 22 Oct 2008 12:10:23 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Yea old defrag
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing this to Theodore Ts'o because he has worked on the package 
in the past, and currently maintains e2fsprogs.   I am CCing lkml since 
there are likely to be other interested parties, and there does not seem 
to be a separate list for e2fsprogs.

The old defrag package for doing offline defragmentation of ext2 has not 
been maintained in many years.  About two years ago I fixed a few bugs 
that were causing it to not work on ext3 and placed the changes in 
Ubuntu.  I would like to see this program continue to live since it 
still serves a purpose, but because it has had no upstream maintainer in 
so long, Debian and thus Ubuntu have dropped the package.  I am trying 
to resurrect it.

I was wondering why it was never integrated into e2fsprogs, and if this 
could now be done.  It seems to me that e2fsprogs would be the proper 
home for it, and a neutral upstream for everyone.  If not, then I will 
try to maintain it as an Ubuntu native package in a bazaar branch on 
launchpad.
