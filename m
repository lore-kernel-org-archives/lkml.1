Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZA3OCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZA3OCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZA3OCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:02:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:36943 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZA3OCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:02:08 -0500
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090127233159.GA26403@elte.hu>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <20090127233159.GA26403@elte.hu>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 19:31:32 +0530
Message-Id: <1233324092.3670.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Wed, 2009-01-28 at 00:31 +0100, Ingo Molnar wrote:

> Jaswider, would you mind re-doing the tree filtering out the CONFIG_* 
> changes? I'll go over the end result once more to make sure it has no 
> changes that make the code look worse.
> 

Sure, why not ;-)

But in your -tip tree you already have these patches. Are you going to
revert them or should I make patches for linus tree.

--
JSR

