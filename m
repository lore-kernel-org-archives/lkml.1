Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXJNKp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXJNKp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXJNKpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:45:17 -0400
Received: from main.gmane.org ([80.91.229.2]:40181 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbXJNKpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:45:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.23(.1) Regression? i915 oopses and panics
Date: Sun, 14 Oct 2007 12:44:57 +0200
Message-ID: <fesrv9$o97$1@ger.gmane.org>
References: <fesqkn$lml$1@ger.gmane.org> <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-56-183.dynamic.qsc.de
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
In-Reply-To: <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie schrieb:
> lets start with:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e4a7b1d1d90d202a030688ab5b177c3c0f15ee3e
> 
> and work from there..

I'm sorry, I forgot to mention that: As I _thought_ it had worked with
rc6, I already found that commit. I reverted it and got a panic again
(no trace, as I was in X), so this one doesn't seem to cause the problem.

