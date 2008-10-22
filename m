Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYJVEZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYJVEZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYJVEZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:25:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58059
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbYJVEZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:25:25 -0400
Date: Tue, 21 Oct 2008 21:25:02 -0700 (PDT)
Message-Id: <20081021.212502.41487120.davem@davemloft.net>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/24] perfmon3: introduction
From: David Miller <davem@davemloft.net>
In-Reply-To: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:07 -0700 (PDT)

> Thanks to all the people who have contributed to this new release.

What about the folks who worked hard on sparc, powerpc, et al. perfmon
support?  Do they "just lose" for the moment?  :-/

I'm really disappointed that I did all of the work to make pfmon,
libpfm, and the kernel bits work with perfmon on sparc and that
appears to be all for nothing as there is no update for those
architectures in this new patch set.  So likely I'll have to do it all
over again.

I definitely do not support this reincarnation, this is the last thing
I expected to happen.

Three weeks of my own work down the drain which I invested (during
which I put my networking maintainership and other responsibilities to
the side) in order to help champion this perfmon stuff in the first
place?

Gee, thanks...
