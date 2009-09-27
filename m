Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZI0A2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZI0A2q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 20:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZI0A2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 20:28:46 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:42544 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZI0A2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 20:28:46 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC] Privilege dropping security module
Date: Sun, 27 Sep 2009 00:28:49 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h9mbk1$b36$1@taverner.cs.berkeley.edu>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090925072248.GB9821@c.hsd1.tn.comcast.net> <h9jaar$url$1@taverner.cs.berkeley.edu> <20090926210958.GA23564@c.hsd1.tn.comcast.net>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1254011329 11366 128.32.168.222 (27 Sep 2009 00:28:49 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 27 Sep 2009 00:28:49 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer  wrote:
>What would you suggest as a better specification language? Would it be
>sufficient to have recursive and non recursive variants for masking
>permissions?

I haven't given it enough thought to recommend a better specification
language.  Having both recursive and non-recursive variants might do
the trick.
