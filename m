Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYGQADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYGQADY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbYGQADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:03:09 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36725 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYGQADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:03:06 -0400
Date: Wed, 16 Jul 2008 18:03:01 -0600
From: Alex Chiang <achiang@hp.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Byron Stanoszek <bstanoszek@comtime.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080717000301.GD22919@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Byron Stanoszek <bstanoszek@comtime.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stoyan Gaydarov <stoyboyker@gmail.com>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <Pine.LNX.4.64.0807150938280.12665@winds.org> <20080716211427.GH31126@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716211427.GH31126@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Sorensen <lsorense@csclub.uwaterloo.ca>:
> 
> Didn't HP-UX 11 come out around a decade ago?  Did they stop
> development?

The short answer is that HP-UX decided to keep major number 11 as
a branding decision, and has released updates such as 11i, 11i v1,
11i v2, etc.

Most recent release was 11i v3, and if you do a uname -a, you'll
see that you get a "real" version, like 11.31.

	http://en.wikipedia.org/wiki/Hpux#Versions

/ac

