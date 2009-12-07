Return-Path: <linux-kernel-owner+w=401wt.eu-S935655AbZLGWaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935655AbZLGWaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935606AbZLGWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:30:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49697 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbZLGWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:30:13 -0500
Date: Mon, 7 Dec 2009 17:28:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michal Marek <mmarek@suse.cz>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: net/kbuild trees build failure
Message-ID: <20091207222853.GE18939@tuxdriver.com>
References: <20091207200317.57820f0a.sfr@canb.auug.org.au> <20091207114158.GA2428@merkur.ravnborg.org> <4B1CF39A.5050806@suse.cz> <20091207160903.GB18939@tuxdriver.com> <1260209537.4653.778.camel@rc-desk> <4B1D76B1.6070601@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D76B1.6070601@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 10:42:09PM +0100, Michal Marek wrote:
> reinette chatre napsal(a):

> > Right - could we please use the solution that works at compile time? I
> > used UTS_RELEASE after learning about its use in init/version.c, would
> > that not make it an approved solution?
> 
> It seems there is some misunderstanding.

Alright, if Stephen's fix is acceptable then your suggestion is fine.
Sam seemed to suggest that Stephen's fix was a stop-gap.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
