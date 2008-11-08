Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYKHPbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYKHPbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYKHPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:31:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:46070 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYKHPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:31:42 -0500
Date: Sat, 8 Nov 2008 07:32:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3 (x86_64) on current Fedora 9 (i386)
Message-ID: <20081108073228.0b98d5ae@infradead.org>
In-Reply-To: <1226157728.6060.7.camel@dhcppc0>
References: <1226157728.6060.7.camel@dhcppc0>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Nov 2008 16:22:08 +0100
Thomas Meyer <thomas@m3y3r.de> wrote:

> Hi,
> 
> Cross compiled with gcc-4.2.4.
> 
> nm-applet seems to constantly fail to connect my wlan:

<sniped a bunch of segfault messages>

it might be interesting to collect a coredump of one of these and 
then use gdb to see where nm-applet fails

maybe that provides a good hint of where things go pear shaped

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
