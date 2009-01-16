Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZAPDmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZAPDmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 22:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760250AbZAPDlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 22:41:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53570 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbZAPDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 22:41:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build problem with nfs tree (Was: Re: [mmotm][PATCH] fix ia64 build error)
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <20090116134930.68e783aa.sfr@canb.auug.org.au>
References: <20090115175917.8e0ae536.akpm@linux-foundation.org> <20090116134930.68e783aa.sfr@canb.auug.org.au>
Message-Id: <20090116123931.EBEF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 16 Jan 2009 12:41:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Andrew,
> 
> On Thu, 15 Jan 2009 17:59:17 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I do most of my gitting across a DSL connection.  It makes GUIs
> > painful.
> 
> Yeah, I will think on it ...
> 
> > > I have dropped the nfs tree from linux-next for today.
> > 
> > Just for this buglet?  That sounds a bit savage.
> 
> There was another problem with the fscache code as well.  Also, this was
> reported the day before yesterday and got no response.  Also, the other
> patch that added EXPORT_SYMBOL(copy_page) "recently" was from
> December, *2007* ... Also, this is 2.6.30 material and they have a long
> time to fix it.
> 
> Also, it is much easier on me :-)

Ghh, sorry for my really poor analysis ;)
thanks stephen.




