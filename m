Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679Ab0A0ABw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab0A0ABw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388Ab0A0ABs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:01:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661Ab0A0ABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:01:46 -0500
Date: Tue, 26 Jan 2010 16:00:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [61/98] Input: i8042 - remove identification strings from DMI
 tables
In-Reply-To: <20100126233928.894956940@mini.kroah.org>
Message-ID: <alpine.LFD.2.00.1001261559240.17519@localhost.localdomain>
References: <20100126233928.894956940@mini.kroah.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jan 2010, Greg KH wrote:
>
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> commit f909b1df0a068f30e252d8dc3e9d45ca25bf266f upstream.
> 
> The driver does not reference identification strings in DMI tables and
> since these strings are no longer required by DMI core we can safely
> remove them and save some memory.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

This seems to have lost your sign-off?

		Linus
