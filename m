Return-Path: <linux-kernel-owner+w=401wt.eu-S937083AbYEBXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937083AbYEBXjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763562AbYEBXjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:39:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40175
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758427AbYEBXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:39:44 -0400
Date: Fri, 02 May 2008 16:39:44 -0700 (PDT)
Message-Id: <20080502.163944.140090564.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: harvey.harrison@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080502163131.a13c0774.akpm@linux-foundation.org>
References: <1209754916.26173.39.camel@brick>
	<20080502.162515.14823435.davem@davemloft.net>
	<20080502163131.a13c0774.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 May 2008 16:31:31 -0700

> On Fri, 02 May 2008 16:25:15 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Date: Fri, 02 May 2008 12:01:56 -0700
> > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > This has to go in via who ever adds the first patch
> > with the actual helpers, so I won't apply this one.
> 
> Yup.  After a bit of testing and tyre-kicking I'll probably slip
> lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> various maintainers.

Please just slurp this networking one in with that, if you
would be so kind.

