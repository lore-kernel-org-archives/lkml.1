Return-Path: <linux-kernel-owner+w=401wt.eu-S932216Ab0AFNrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0AFNrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 08:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144Ab0AFNrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 08:47:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:36728 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab0AFNq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 08:46:59 -0500
Date: Wed, 6 Jan 2010 14:46:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Christian Schuerer <csw@xray.at>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux-2.6.31.9, linux-2.6.32.2, linux-2.6.33-rc2 -- Re:
 Device IDs for new Apple Wireless Keyboard
In-Reply-To: <201001061357.22447.csw@xray.at>
Message-ID: <alpine.LNX.2.00.1001061446450.2277@pobox.suse.cz>
References: <4B38AFDE.8000203@gmail.com> <201001060216.47958.csw@xray.at> <alpine.LNX.2.00.1001061113060.2277@pobox.suse.cz> <201001061357.22447.csw@xray.at>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Christian Schuerer wrote:

> > > here is the patch for linux-2.6.33-rc2:
> > > Thanks. Unfortunately, it's wordwrapped, so it can't be easily applied.
> > Could you please fix up your e-mail client so that it doesn't mangle long
> > lines, or eventually send is as an attachment?
> 
> I'm sorry, I have attached all three patches as text files.
> 
> > > Added device IDs for the new model of the Apple Wireless Keyboard
> > > (November 2009).
> > These are solely Bluetooth device, and there is no USB variant, right?
> 
> As far as I know of only a new variant of the wireless (bluetooth) keyboard 
> has been released in November 2009.

Applied to my tree, thanks Christian.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
