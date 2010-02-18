Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0BRXe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:34:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58239 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221Ab0BRXe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:34:26 -0500
Date: Thu, 18 Feb 2010 23:37:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Ball <cjb@laptop.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
Message-ID: <20100218233756.18bcc16d@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1002182300520.30967@pobox.suse.cz>
References: <20100218095200.63509b8c@bike.lwn.net>
	<m37hqamlau.fsf@pullcord.laptop.org>
	<alpine.LNX.2.00.1002182300520.30967@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we could nuke them all, but I'd suggest first checking with 
> maintainers of the code in question. It's possible that they do some kind 
> of auto-import from some weird external repositories in which they 
> auto-generate this Changelog file, so they might re-appear later (not 
> everyone is using git even these days ... strange, but apparently true).

I think I'm the nearest thing to a parport maintainer these days - no
objection from me there.

Anyway its in the git log
