Return-Path: <linux-kernel-owner+w=401wt.eu-S1763160AbXELAX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763160AbXELAX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXELAXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:23:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbXELAXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:23:51 -0400
Message-ID: <46450910.8080503@zytor.com>
Date: Fri, 11 May 2007 17:23:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <4645032E.1030109@gmail.com>
In-Reply-To: <4645032E.1030109@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Not sure if you were looking for testing, but I fuzzed it to apply to
> 2.6.21-git and gave it a spin.  Worked just like a normal boot (which I
> assume was the point).

That would be the point, yes :)  Looking for breakage in video mode
detection, memory detection, and APM are probably the trickiest areas.

	-hpa
