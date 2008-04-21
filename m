Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYDUXy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYDUXy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYDUXys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:54:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51943
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYDUXys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:54:48 -0400
Date: Mon, 21 Apr 2008 16:54:49 -0700 (PDT)
Message-Id: <20080421.165449.237670695.davem@davemloft.net>
To: rdreier@cisco.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <adak5iqakle.fsf@cisco.com>
References: <20080421.153231.108090227.davem@davemloft.net>
	<adak5iqakle.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 21 Apr 2008 15:50:37 -0700

>  > This performs the scheduled removal of Solaris and SunOS
>  > system call for sparc, much to the chagrin of Al Viro
>  > and others :-) (in particular, that asm/namei.h crud can
>  > now die)
> 
> Maybe this is an inside joke I don't get, but why are we merging
> something that causes Al Viro and others to feel chagrin?

Sorry, I definitely used to wrong word.  I mean it would make
people like Al pleased.
