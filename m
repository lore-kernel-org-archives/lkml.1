Return-Path: <linux-kernel-owner+w=401wt.eu-S933388AbXDCI4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbXDCI4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXDCI4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:56:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:44650 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933388AbXDCI4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:56:30 -0400
Date: Tue, 3 Apr 2007 11:00:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>, Paul Walmsley <paul@booyaka.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
In-Reply-To: <4611B0A1.8070106@gmail.com>
Message-ID: <Pine.LNX.4.64.0704031058240.3808@jikos.suse.cz>
References: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
 <4611B0A1.8070106@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Li Yu wrote:

> May be, we need some means to change blacklist in runtime.

Paul Walmsley (added to CC) sent me patches some time ago that among other 
things implemented possibility to modify the hid_blacklist[] in runtime. 
The patches had some issues which Paul said will fix - Paul, what is the 
current status please?

Thanks,

-- 
Jiri Kosina
