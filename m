Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbYECJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbYECJ3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbYECJ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:29:46 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:59960 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbYECJ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:29:45 -0400
Message-ID: <481C3087.8020501@free.fr>
Date: Sat, 03 May 2008 11:29:43 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-3)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, joern@logfs.org,
       linux-mtd@lists.infradead.org
Subject: Re: LogFS merge
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 2, 2008 at 4:32 PM, Jörn Engel <joern@logfs.org> wrote:
 >  not being familiar with either maintaining my own git tree or the -next
 >  process, I'd still like to get logfs into mainline.  It has gone through
 >  six rounds of reviews and the last has been mostly about crossing some
 >  i's here and dotting some t's there.
 >
 >  So should it simmer in -next and -mm for another month?  Should it go
 >  straight into -linus?
Shouldn't this get review by mtd guys first ?

Also for info, there have been some issue raised by the ubifs developer [1].

Matthieu

[1] http://thread.gmane.org/gmane.linux.kernel/658740/focus=660392
