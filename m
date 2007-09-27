Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbXI0NNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbXI0NNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 09:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXI0NNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 09:13:13 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47784 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbXI0NNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:13:13 -0400
Date: Thu, 27 Sep 2007 15:13:10 +0200
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ext2-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel Oops in ext3 code
Message-ID: <20070927131310.GD6093@gamma.logic.tuwien.ac.at>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at> <200709271425.06470.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709271425.06470.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 27 Sep 2007, Rafael J. Wysocki wrote:
> Does it happen with 2.6.22?

Hard to say. It didn't happen as long as I used -22, but it didn't
happen for a long time (since I run -rc6), and it is not reproducible.

What I did at this time is a:
	tar -cjf foo.tar.bz2 a-big-dir-with-more-than-800Mb
I retried it again with -rc6 and it succeeded. So hard to say.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
ALDCLUNE (n.)
One who collects ten-year-old telephone directories.
			--- Douglas Adams, The Meaning of Liff
