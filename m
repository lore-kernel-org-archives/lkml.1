Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbYITQiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYITQiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYITQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:38:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43524 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbYITQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:38:47 -0400
Date: Sat, 20 Sep 2008 17:38:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] Fix backspace on wrapped lines in console (virtual
 terminal)
Message-ID: <20080920173822.51794923@lxorguk.ukuu.org.uk>
In-Reply-To: <48D5240D.7070701@skyrush.com>
References: <48D5240D.7070701@skyrush.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 10:25:49 -0600
Joe Peterson <joe@skyrush.com> wrote:

> Attached is a patch that fixes virtual terminal problems when backspace
> is used on wrapped lines (see patch text for the specific issues).  The
> issues can be demonstrated by trying two things in the console (vt):

I would need to power up my vt420 to check (yes I have one lurking in a
corner!) but I have a feeling the current behaviour (not going up a line)
is correct for ansi type terminals.

Alan
