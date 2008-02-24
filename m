Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYBXFIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYBXFIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYBXFIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:08:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:45830 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750912AbYBXFI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:08:29 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19+xVc+ZkJ+jWpn6cb9ig7eDTdt+Hmz5Y9po09Ahe
	9H82vpUuZj425d
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt
	switch.
From: Mike Galbraith <efault@gmx.de>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
	 <20080223221750.429cf0d9@bree.surriel.com>
	 <998d0e4a0802232008w5c6566f0se15ab749ec6f1ceb@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 06:08:25 +0100
Message-Id: <1203829705.7554.30.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 05:08 +0100, J.C. Pizarro wrote:

> One reason: for the objective of gain interactivity, it's an issue that
>  CFS fair scheduler lacks it.

A bug report would be a much better first step toward resolution of any
interactivity issues you're seeing than posts which do nothing but
suggest that there may be a problem.

First define the problem, _then_ fix it.

	-Mike

