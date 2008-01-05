Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYAEJbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYAEJbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYAEJbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:31:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754641AbYAEJbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:31:15 -0500
Date: Sat, 5 Jan 2008 01:30:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: nigel@nigel.suspend2.net
Cc: Berthold Cogel <cogel@rrz.uni-koeln.de>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
Message-Id: <20080105013056.551cf3b5.akpm@linux-foundation.org>
In-Reply-To: <477AADF4.4080305@nigel.suspend2.net>
References: <477A93CD.9030707@rrz.uni-koeln.de>
	<477AADF4.4080305@nigel.suspend2.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 08:17:40 +1100 Nigel Cunningham <nigel@nigel.suspend2.net> wrote:

> Hi Berthold.
> 
> > The USB system seems to be a wreck at the moment after the Oops. lsusb
> > and usbview don't work. But keyboard and trackball are still working.
> 
> If you can reproduce it, would you please send the information to the
> USB maintainers? I don't modify USB drivers, so it will be an issue in
> vanilla. Even if you can't reproduce it immediately, they may well like
> to see this report.

please also cc Dmitry, who looks after the evdev code.  Also maybe Jiri who
works on related stuff (I've never understood the division, so when in
doubt, I spam 'em both).

