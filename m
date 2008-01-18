Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYARAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYARAit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYARAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:36:53 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:36184 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178AbYARAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:36:52 -0500
Message-ID: <478FF4F2.2050004@skyrush.com>
Date: Thu, 17 Jan 2008 17:38:10 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] (*revised*) Fix IXANY and restart after signal (e.g.
 ctrl-C) in n_tty line discipline
References: <476D1D0E.6000302@skyrush.com>	<478FE861.4000705@skyrush.com> <20080117161156.92737c80.akpm@linux-foundation.org>
In-Reply-To: <20080117161156.92737c80.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> What were the "couple of issues"?

They are the same 2 issues described in the original version of the
patch and included in the text of this one too (i.e. the text at the
start of this latest patch version is the same as before).

>> This patch should *replace* the old version of the patch.
> 
> I don't like replacements a lot.  It forces one to re-review the whole
> thing from scratch.  Which is why I almost always turn the replacement
> into an incremental patch, as below.

I see your point.  Cool, thanks for making the update patch, and I'll
submit them like that in the future.

					-Thanks, Joe
