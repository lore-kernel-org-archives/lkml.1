Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383Ab0ADK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0ADK5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345Ab0ADK5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:57:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0ADK5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:57:35 -0500
Date: Mon, 4 Jan 2010 11:57:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>,
       Christian Schuerer-Waldheim <csw@xray.at>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Device IDs for new Apple Wireless Keyboard
In-Reply-To: <4B38AFDE.8000203@gmail.com>
Message-ID: <alpine.LNX.2.00.1001041155560.2277@pobox.suse.cz>
References: <4B38AFDE.8000203@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009, Jiri Slaby wrote:

> Hi, I added some proper CCs. For me they look good. Care to add
> signed-off-by line? Thanks.
> 
> ---- original message ----
> Hello Jiri,
> 
> I'm writing to you because you are the last in the list of contributors
> in the
> file hid-apple.c of the linux kernel.
> 
> Since November 2009 Apple is selling a new make of its Wireless 
> Keyboard, which have new device IDs. In order to make the kernel driver 
> hid-apple to take care about this new devices, the new IDs have to be 
> added. I've created patches for the 2.6.31 and 2.6.32 kernel. Could you 
> please integrate them into the main kernel?
> 
> If you are not responsible for it anymore, please tell me whom I may 
> contact instead. Thank you!

Christian,

thanks for the patch. Could you please make the following two updates to 
it, and send it to me, so that I could merge it? Thanks.

- add a proper Signed-off-by: line, as described in 
  Documentation/SubmittingPatches
- keep the list of Apple IDs ordered by the product number

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
