Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbXLZTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbXLZTXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 14:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXLZTXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 14:23:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXLZTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 14:23:09 -0500
Message-ID: <4772AA13.4030004@zytor.com>
Date: Wed, 26 Dec 2007 11:22:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com> <20071226190045.GB8094@elf.ucw.cz>
In-Reply-To: <20071226190045.GB8094@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> Yep... for the first version, I'll be very happy if it autosleeps when
> I'm traveling by bus or something. Working with ethernet plugged in is
> quite a distant goal.
> 
> (But I guess some cleverness could be done on the router or
> something. Automagically converting "interesting" packets into WoL
> enabled ones, or...?)
> 									Pavel

You've just eliminated 90%+ of the available Ethernet infrastructure.

However, there may be Ethernet controllers which can do something smart 
with incoming packets, and perhaps more importantly, we can always write 
a spec and try to push it to Intel, Broadcom, Realtek and Nvidia.

	-hpa
