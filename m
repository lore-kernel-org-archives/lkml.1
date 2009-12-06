Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbZLFR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbZLFR2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933986AbZLFR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:28:30 -0500
Received: from tex.lwn.net ([70.33.254.29]:37532 "EHLO tex.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981AbZLFR2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:28:30 -0500
X-Greylist: delayed 1674 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 12:28:30 EST
Date: Sun, 6 Dec 2009 10:01:03 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: David Miller <davem@davemloft.net>, joe@perches.com, brice@myri.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] drivers/net: Move && and || to end of
 previous line
Message-ID: <20091206100103.427f0049@tpl.lwn.net>
In-Reply-To: <4B1B1E59.1030307@gmail.com>
References: <4B190A29.5080905@myri.com>
	<1259947271.22783.120.camel@Joe-Laptop.home>
	<4B1A557D.4080707@gmail.com>
	<20091205.142126.23618243.davem@davemloft.net>
	<4B1B1E59.1030307@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Dec 2009 22:00:41 -0500
William Allen Simpson <william.allen.simpson@gmail.com> wrote:

> > You come out of nowhere as a new contributor.  You have to constantly
> > ask about policy and other formalities wrt. kernel development.
> >   
> Because they are not documented.  Oh, and a reminder -- you've not
> answered my most recent questions....

Might I suggest a look at Documentation/HOWTO and
Documentation/development-process/?  You might find that more of this
stuff is better documented than you think.  If there are gaps, please
let us know where they are, and we'll endeavor to fill them in.

jon
