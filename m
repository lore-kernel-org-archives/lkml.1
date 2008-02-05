Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbYBEX5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbYBEX5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbYBEX5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:57:14 -0500
Received: from www17.your-server.de ([213.133.104.17]:37988 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759903AbYBEX5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:57:14 -0500
Message-ID: <1202255831.47a8f7d79b937@213.133.104.17>
Date: Wed, 06 Feb 2008 00:57:11 +0100
From: thomas@m3y3r.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17> <47A8E427.6040205@zytor.com>
In-Reply-To: <47A8E427.6040205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.237.226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von "H. Peter Anvin" <hpa@zytor.com>:

> thomas@m3y3r.de wrote:
> > The latest linux kernel doesn't boot on my computer
> > (h=21511abd0a248a3f225d3b611cfabb93124605a7).
> > 
> > elilo hangs while booting this kernel. 2.6.24 works.
> 
> Wow, so we know it's affected with EFI, since you're using elilo.
> 
> You gave absolutely zero other information about your system or what 
> "doesn't boot" mean.

It's a macbook pro with a core duo processor (the one with only 32bits).


Doesn't boot means: i enter the name of the kernel image i want to boot in elilo
and press enter and nothing happens, it just hangs.

i need to press the power button for a few seconds to power off.



