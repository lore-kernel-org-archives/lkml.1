Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab0BLFcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:32:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab0BLFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:32:31 -0500
Date: Thu, 11 Feb 2010 21:27:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: oops in uevent_helper [was: mmotm 2010-01-13-12-17 uploaded]
Message-Id: <20100211212708.aa5bec1f.akpm@linux-foundation.org>
In-Reply-To: <20100212052126.GA21783@one.firstfloor.org>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
	<4B50C2FA.4020100@gmail.com>
	<4B50FC78.9010107@gmail.com>
	<20100122155237.e93a1c55.akpm@linux-foundation.org>
	<4B730EE3.4080405@gmail.com>
	<20100211205745.GA18202@basil.fritz.box>
	<20100211142513.b1fd6e7a.akpm@linux-foundation.org>
	<20100212052126.GA21783@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 06:21:26 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> > urgh, must I?  That trashes Neil's
> > kmod-add-init-function-to-usermodehelper.patch and
> > kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
> > and probably requires repairing other stuff and sets the testing status
> > back to "square one".
> > 
> > If you have patches queued, please make the time to support them!
> 
> Ok, understood. I'll try to look into it today.

Ta.  As I mentioned to Neil, if it looks serious then let's shelve it
all and revisit for 2.6.35.

> You want incrementals?

If convenient, please.  Otherwise we can drop--and-remerge.
