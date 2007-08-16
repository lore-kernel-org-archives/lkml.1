Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbXHPPy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbXHPPy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbXHPPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:54:48 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60344 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbXHPPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:54:47 -0400
Message-ID: <46C47246.9020800@gmail.com>
Date: Thu, 16 Aug 2007 17:50:30 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Salikh Zakirov <salikh@gmail.com>,
       Junio C Hamano <gitster@pobox.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, git@vger.kernel.org
Subject: Re: [linux-pm] Re: Storing Maintainers info around the kernel tree
References: <Pine.LNX.4.44L0.0708161128540.3757-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708161128540.3757-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2007 05:31 PM, Alan Stern wrote:

> Please remember that not everybody uses git.  The MAINTAINERS data 
> should be available in the kernel source itself.

It may be useful to generate a MAINTAINERS file into releases yes.

I must say though that "why?" would also be a question. I personally don't 
think there's a whole lot wrong with more and more expecting people who 
submit patches (for whom this automation is intended) to be using git. Back 
in the BK days there were lots of reasons for resisting any and all 
dependency on the source code management tool but there don't seem to be too 
many left today as far as I'm concerned.

If it's about non-developer users, I suspect it would to a fairly large 
degree be an "in theory" thing to expect that said user does want the 
information in a downloaded releases, but not in git, and not online where 
git-web could also easily display all the information right alongside the files.

But yes, sure, anything can be generated...

Rene.
