Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbXJZJQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbXJZJQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbXJZJQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:16:33 -0400
Received: from www.tglx.de ([62.245.132.106]:32977 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbXJZJQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:16:32 -0400
Date: Fri, 26 Oct 2007 11:16:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Lothian <mike@fireburn.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
In-Reply-To: <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0710261115130.3186@localhost.localdomain>
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Oct 2007, Michael Lothian wrote:

> Hi
> 
> I was wondering if it was possible to add -march=native support to the
> processor options of the new x86 architecture if gcc 4.2 or greater is being
> used.
> 
> I'm not suggesting this should be a default at all, merely an extra option
> similar to selecting P4, Athlon or even -Os.
> 
> I've manually tried this flag at home with no ill effects.

It works for your specific setup, but it will kill distro compiles as
well as cross compiling.

     tglx
