Return-Path: <linux-kernel-owner+w=401wt.eu-S1030935AbXDVO6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030935AbXDVO6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030936AbXDVO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:58:17 -0400
Received: from 1wt.eu ([62.212.114.60]:2207 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030935AbXDVO6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:58:17 -0400
Date: Sun, 22 Apr 2007 16:57:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: Urs Thuermann <urs@isnogud.escape.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.34.3
Message-ID: <20070422145752.GR943@1wt.eu>
References: <20070422101057.GA11893@hera.kernel.org> <ygfzm508reh.fsf@janus.isnogud.escape.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygfzm508reh.fsf@janus.isnogud.escape.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 03:33:58PM +0200, Urs Thuermann wrote:
> Willy Tarreau <wtarreau@hera.kernel.org> writes:
> 
> > I've just released Linux 2.4.34.3.
> > 
> > Nothing critical, just a bunch of bugfixes and small security fix.
> 
> I get the following compile error:

[snip]

Grrr... I'm very sorry. Thanks for your patch, I'll fix it and 35-pre3 at the
same time. I think I should do -rc1 as does Adrian on 2.6, but it's twice as
much work.

Thanks,
Willy

