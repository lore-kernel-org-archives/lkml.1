Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbXGRBwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbXGRBwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXGRBwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:52:24 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:48191 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbXGRBwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:52:23 -0400
Message-ID: <469D71FB.5070408@gentoo.org>
Date: Tue, 17 Jul 2007 21:50:51 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
In-Reply-To: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sasa Ostrouska wrote:
> I want to ask one question about a custom resolution in the console.
> I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> ugly as I get a border of about 2-3cm on one the sides of the screen.
> So is there a way that I set the 1280x800 resolution at boot time ?

I don't think vesafb can do what you want. However, uvesafb probably can.

http://dev.gentoo.org/~spock/projects/uvesafb/

Daniel

