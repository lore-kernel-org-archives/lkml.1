Return-Path: <linux-kernel-owner+w=401wt.eu-S932955AbXA1Wwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955AbXA1Wwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXA1Wwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:52:34 -0500
Received: from main.gmane.org ([80.91.229.2]:56474 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbXA1Wwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:52:33 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [SCRIPT] Remove "space damage" from patches
Date: Sun, 28 Jan 2007 22:52:17 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerqapg.f71.olecom@flower.upol.cz>
References: <45BD177D.6060907@student.ltu.se>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Oleg Verych <olecom@flower.upol.cz>, Andrew Morton <akpm@osdl.org>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Richard Knutsson
> Newsgroups: gmane.linux.kernel
> Subject: [SCRIPT] Remove "space damage" from patches
> Date: Sun, 28 Jan 2007 22:37:01 +0100

> Hello Andrew and all

Hallo.

> I recently tried "git-apply" on the 2.6.20-rc6-mm1 patch and found it to complain about white-spaces.
> So as a mean to (hopefully) cut down on these nasty white-spaces (and sometimes tabs) I wrote this
> little script. All it does is checking (lines that are going to be added) for spaces before tabs
> and trailing spaces/tabs. I tried it on 2.6.20-rc6-mm1 and it seem to work well
>
> If there is someone interested, _please_ take it. Any suggestion are welcomed :)
>
> Richard Knutsson

Nack, big and fat. It's userspace problem.

If our "developers" can't use or update their every-day-tools, it's a
shame. And this is not trolling: i'm using Jed and GNU Emacs, both are
ok with whitespace "production". 

____

