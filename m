Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXHRV6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXHRV6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 17:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbXHRV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 17:58:17 -0400
Received: from gw.goop.org ([64.81.55.164]:56588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794AbXHRV6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 17:58:16 -0400
Message-ID: <46C76B75.5040008@goop.org>
Date: Sat, 18 Aug 2007 14:58:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
 issue
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <200708181149.48217.ak@suse.de>
In-Reply-To: <200708181149.48217.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This patch breaks Xen booting.  
>>     
>
> Check the latest git head. Does it still break?

Yes, that's with latest git head.

    J
