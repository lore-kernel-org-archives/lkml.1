Return-Path: <linux-kernel-owner+w=401wt.eu-S1161630AbXD3Eiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161630AbXD3Eiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161633AbXD3Eiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:38:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161630AbXD3Eiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:38:50 -0400
Message-ID: <463572B7.90202@zytor.com>
Date: Sun, 29 Apr 2007 21:38:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <1177902195.30071.203.camel@localhost.localdomain>
In-Reply-To: <1177902195.30071.203.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> Dammit, Eric, you spend a lot of time using words like "insane" where
> you mean we didn't do everything all at once.
> 
> It's *not* clear that using %esi is sane, but nothing in the current
> code prevents that.
> 

Why not?

	-hpa
