Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbXJQMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbXJQMdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXJQMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:33:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50316 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbXJQMdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:33:04 -0400
Date: Wed, 17 Oct 2007 21:33:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: 2.6.23-mm1
Message-Id: <20071017213312.60475b86.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0710171340580.18815@twin.jikos.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
	<20071017183626.70bdd13e.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0710171340580.18815@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 13:42:04 +0200 (CEST)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Wed, 17 Oct 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > Oh well, this causes more trouble that I have ever imagined ... I will 
> > > look into it, thanks a lot for the report. Andrew, please drop this 
> > > one again, I will fix it up.
> > Maybe this can be fix.
> 
> Hi Kame,
> 
> yes, this looks correct to me. Did you verify that it makes the problem 
> you are seeing go away?
> 
yes. I confirmed this works well.

-Kame
