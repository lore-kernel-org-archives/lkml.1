Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXHLQ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXHLQ4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXHLQ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:56:36 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:59489 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbXHLQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:56:35 -0400
Date: Sun, 12 Aug 2007 18:56:25 +0200
From: Andreas Radke <a.radke@arcor.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20.16 review 00/28] 2.6.20.16 -stable review
Message-ID: <20070812185625.19f422e9@workstation64.home>
In-Reply-To: <8R4lZ-5Xs-9@gated-at.bofh.it>
References: <8R4lZ-5Xs-9@gated-at.bofh.it>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat, 11 Aug 2007 21:00:15 +0200
schrieb Willy Tarreau <w@1wt.eu>:

> My goal is *not* to do all the hard work they do, but just to backport
> from their patches those which are meaningful for 2.6.20. For this
> reason, 2.6.20 releases will always be slightly late and should not
> contain patches not merged in more recent releases.
> 
> My intent with this version is to catch up with 2.6.21.7. Other
> patches are already pending for future releases, but one thing at a
> time. I'm trying to follow the same review/release process, so 28
> patches will be posted for review in response to this message.

hm. i'm a bit confused about your intention.

will you keep maintaining 2.6.20.x for longer? should this one replace
or live along the 2.6.16.xx long life series?

Andreas Radke
ArchLinux x86_64 developer/maintainer
