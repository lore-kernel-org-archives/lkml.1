Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919Ab0ADAzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0ADAzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858Ab0ADAzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:55:53 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:33591 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0ADAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:55:52 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Date: Mon, 4 Jan 2010 00:55:52 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhreao$r8k$1@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org> <20100101144629.54fe6cb6@lxorguk.ukuu.org.uk> <hhmoos$vnu$1@taverner.cs.berkeley.edu> <20100102135525.08fe85eb@lxorguk.ukuu.org.uk>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262566552 27924 128.32.153.193 (4 Jan 2010 00:55:52 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 4 Jan 2010 00:55:52 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox  wrote:
> I am just pointing out the dangers of continuing to blindly pursue that
> model without thinking about the bigger picture.

But people have been thinking about the bigger picture.
Indeed, that's the motivation for the patch proposed here.
I don't know why you think people have ignored the bigger picture.
