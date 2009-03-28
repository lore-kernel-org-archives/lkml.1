Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZC1Gv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZC1Gv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 02:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZC1GvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 02:51:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:35763 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752304AbZC1GvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 02:51:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19naidRP65nChXVdGltxKF9V0sJYTc7ngxlGlmVfM
	15l7hiAEEEy+Nw
Subject: Re: Linux 2.6.29
From: Mike Galbraith <efault@gmx.de>
To: 7eggert@gmx.de
Cc: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <E1LnJzS-0001vn-Vf@be1.7eggert.dyndns.org>
References: <cjGbn-6Xx-35@gated-at.bofh.it> <cjGl4-7ak-61@gated-at.bofh.it>
	 <cjJsv-3Uu-5@gated-at.bofh.it> <cjKHX-5MF-19@gated-at.bofh.it>
	 <ck7XP-JA-13@gated-at.bofh.it> <ck8h7-18H-1@gated-at.bofh.it>
	 <ck8AA-1y0-7@gated-at.bofh.it> <ck8Kd-20o-7@gated-at.bofh.it>
	 <ckaVR-5o8-9@gated-at.bofh.it> <ckbf4-5M8-7@gated-at.bofh.it>
	 <ckcE8-845-9@gated-at.bofh.it>  <E1LnJzS-0001vn-Vf@be1.7eggert.dyndns.org>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 07:51:08 +0100
Message-Id: <1238223068.5983.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 22:53 +0100, Bodo Eggert wrote:

> data=ordered is a sane way of handling data. Otherwise, the millions
> would change their ext3 to data=writeback.

This one of the millions did that quite a while ago.  Sanity be damned,
my quality of life improved by doing so.

	-Mike

