Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZK0K7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZK0K7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 05:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZK0K7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 05:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZK0K7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 05:59:22 -0500
Date: Fri, 27 Nov 2009 11:59:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alex Custov <alex.custov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: touchscreen wirh 2.6.26
In-Reply-To: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Alex Custov wrote:

> I have Acer T230H on Debian Lenny with 2.6.26.8 manually complied 
> kernel. The problem is that this is a multitouch monitor and it seems 
> that it doesn't work at all (even single touches). All things under 
> "Drivers => Input device support => Touchscreens" are enabled in kernel 
> (as modules). Is this type of monitor supported, or I should upgrade to 
> a newer kernel? Thanks.

How is the touchscreen conntected to system? Is it USB? If so, what is the 
vendor and product ID? (lsusb will tell).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

