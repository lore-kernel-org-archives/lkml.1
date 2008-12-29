Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYL2LuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYL2LuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYL2LuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:50:12 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:16286 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbYL2LuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:50:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.489
Message-ID: <4958B96E.2090709@tremplin-utc.net>
Date: Mon, 29 Dec 2008 12:50:06 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: for.poige+linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest
 stable version of the Linux kernel is".
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
In-Reply-To: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Podlesny schreef:
> Actually that's either a mistake or I don't know what you guys call "a
> stable version".
[removing all the part which needs bug report numbers]

I agree with you that the website is not very clear for someone not
accustomed to the Linux kernel development. There are actually more
stable versions available but they are not advertised. Maybe there
should be more trees displayed, something like this:
The latest stable version of the Linux kernel is:  	2.6.28
The previous stable version of the Linux kernel is:  	2.6.27.10
The latest longtime version of the Linux kernel is:  	2.6.16.62
:

They correspond respectively to Linus'/stable team's tree, the stable
team's tree of the previous version (which keeps being updated even
after the latest Linus' stable release) and Adrian Bunk's tree.

Eric

