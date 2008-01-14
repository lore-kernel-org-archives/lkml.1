Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYANQSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYANQSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYANQRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:17:55 -0500
Received: from main.gmane.org ([80.91.229.2]:50614 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbYANQRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:17:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Mon, 14 Jan 2008 16:17:17 +0000 (UTC)
Message-ID: <slrnfon2od.qhs.tuomov@jolt.modeemi.cs.tut.fi>
References: <18307.42821.166376.732473@stoffel.org> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <b6c5339f0801140810s54ab5d39t2eb2d97c253089b0@mail.gmail.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-14, me@bobcopeland.com <me@bobcopeland.com> wrote:
> It sounds like you have CONFIG_PM_TRACE turned on.  From the Kconfig help:

It isn't listed in /proc/config.gz. No, I don't think I even have 
swsusp stuff compiled in, if it's related to that.

-- 
Tuomo

