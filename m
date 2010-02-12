Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0BLDMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:12:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850Ab0BLDMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:12:03 -0500
Date: Thu, 11 Feb 2010 19:10:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@suse.de>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-Id: <20100211191051.4a73966a.akpm@linux-foundation.org>
In-Reply-To: <20100212023934.GA2210@localhost.localdomain>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
	<4B50C2FA.4020100@gmail.com>
	<4B50FC78.9010107@gmail.com>
	<20100122155237.e93a1c55.akpm@linux-foundation.org>
	<4B730EE3.4080405@gmail.com>
	<20100211205745.GA18202@basil.fritz.box>
	<20100211142513.b1fd6e7a.akpm@linux-foundation.org>
	<20100212023934.GA2210@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 21:39:34 -0500 Neil Horman <nhorman@tuxdriver.com> wrote:

> Andrew, I'll take a closer look at it first thing in the morning.  If we can at
> all help it, I'd really like to avoid dropping the whole series.  I'll let you
> know just as soon as I have something.

Thanks.

If it isn't obvious then I suggest you give up - we're at -rc7 and it's
getting pretty late for these patches.  We'll soon need to shelve them
and respin yours against mainline.

