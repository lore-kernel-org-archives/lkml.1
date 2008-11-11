Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYKKWsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYKKWsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYKKWsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:48:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:42405 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751219AbYKKWsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:48:32 -0500
Date: Tue, 11 Nov 2008 23:48:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Complete support for the new unibody macbooks
In-Reply-To: <4919C979.3000501@euromail.se>
Message-ID: <alpine.LNX.1.10.0811112347260.24889@jikos.suse.cz>
References: <49109C91.6090207@euromail.se> <alpine.LNX.1.10.0811111835540.24889@jikos.suse.cz> <4919C979.3000501@euromail.se>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Henrik Rydberg wrote:

> No worries. I should have mentioned earlier that the hid update is best 
> synchronized with the bcm5974 update, since the latter is the only 
> driver that will pick the mouse interface up after the hid update. The 
> bcm5974 patch was sent on October 23, but I have not received any 
> feedback to it yet.

Yes, I am aware of bcm5974 being dependent in HID driver not claiming the 
mouse interface on this hardware.

Dmitry, what are your plans with this bcm5974 patch? 2.6.28 or 2.6.29?

Thanks,

-- 
Jiri Kosina
SUSE Labs
