Return-Path: <linux-kernel-owner+w=401wt.eu-S936792AbYEBXnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936792AbYEBXnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932498AbYEBXnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:43:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765928AbYEBXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:43:34 -0400
Date: Fri, 2 May 2008 16:43:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: harvey.harrison@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] net: use the common ascii hex helpers
Message-Id: <20080502164304.a79db618.akpm@linux-foundation.org>
In-Reply-To: <20080502.163944.140090564.davem@davemloft.net>
References: <1209754916.26173.39.camel@brick>
	<20080502.162515.14823435.davem@davemloft.net>
	<20080502163131.a13c0774.akpm@linux-foundation.org>
	<20080502.163944.140090564.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 16:39:44 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Fri, 2 May 2008 16:31:31 -0700
> 
> > On Fri, 02 May 2008 16:25:15 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > Date: Fri, 02 May 2008 12:01:56 -0700
> > > 
> > > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > 
> > > Acked-by: David S. Miller <davem@davemloft.net>
> > > 
> > > This has to go in via who ever adds the first patch
> > > with the actual helpers, so I won't apply this one.
> > 
> > Yup.  After a bit of testing and tyre-kicking I'll probably slip
> > lib-add-ascii-hex-helper-functions.patch into mainline so that we can
> > trickle all the *-use-the-common-ascii-hex-helpers.patch patches out to the
> > various maintainers.
> 
> Please just slurp this networking one in with that, if you
> would be so kind.

No probs.  Always happy to do that - more people should tell me "stop being
an ass and just merge it" ;)

