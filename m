Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbXKNVbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbXKNVbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXKNVbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:31:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXKNVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:31:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Wed, 14 Nov 2007 22:48:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473B5987.60904@gmail.com>
In-Reply-To: <473B5987.60904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142248.59547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 14 of November 2007, Jiri Slaby wrote:
> On 11/14/2007 02:59 AM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> Doesn't suspend for me (neither broken-out-2007-11-13-04-14 did) on x86_64.
> echo mem >/sys/power/state
> causes shut down of disk(s) and blinking cursor on 1,1 position.
> The last working was 2.6.23-rc8-mm2. I haven't tested
> 2.6.23-mm1, since it didn't work for me.
> 
> As usual, I don't know how to debug this and what other info is needed, any
> thoughts?

Does the current mainline work?

Rafael
