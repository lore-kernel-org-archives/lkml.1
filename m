Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYGREPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYGREPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYGREPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:15:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYGREPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:15:24 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <200807172242.51251.rjw@sisk.pl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <200807162328.37754.rjw@sisk.pl>
	 <1216248152.1862.21.camel@shinybook.infradead.org>
	 <200807172242.51251.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 21:15:07 -0700
Message-Id: <1216354507.6672.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 22:42 +0200, Rafael J. Wysocki wrote:
>   HOSTCC  firmware/ihex2fw - due to: FORCE
> /home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error:
> opening dependency file firmware/.ihex2fw.d: Read-only file system
> compilation terminated.

I believe you can't reproduce this with Linus' current HEAD?
Please poke me if it happens again.

-- 
dwmw2

