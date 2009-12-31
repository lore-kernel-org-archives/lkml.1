Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZLaRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZLaRzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 12:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZLaRza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 12:55:30 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:55889 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZLaRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 12:55:29 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Date: Thu, 31 Dec 2009 17:55:27 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhioif$j9t$3@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org> <m2bphfti1u.fsf@ssh.synack.fr> <e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com> <20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262282127 19773 128.32.153.193 (31 Dec 2009 17:55:27 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 31 Dec 2009 17:55:27 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox  wrote:
>Removing specific features from a specific piece of code
>generally isn't a security feature -

You lost me there.  The ability of a specific piece of code to voluntarily
relinquish privileges can be a big benefit to security.  It enables
privilege-separated software architectures, which are a powerful way to
reduce risk.  That's the motivation for the disablenetwork proposal that
has stimulated all this discussion.  I hope this is obvious?  Does it
need elaboration?
