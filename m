Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXBOK5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXBOK5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965623AbXBOK5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:57:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXBOK5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:57:37 -0500
Date: Thu, 15 Feb 2007 02:56:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?ISO-8859-1?B?Uy7HYT8/bGFy?= Onur <caglar@pardus.org.tr>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Message-Id: <20070215025659.b5b78d2e.akpm@linux-foundation.org>
In-Reply-To: <20070215104032.GL26240@elf.ucw.cz>
References: <200702090838.21060.caglar@pardus.org.tr>
	<20070215104032.GL26240@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 11:40:32 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> Contact fbcon people...

There aren't any, basically.  Since Tony disappeared James has been helping out
but doesn't have a lot of time.  So we're pretty much on our own with problems in
this area.
