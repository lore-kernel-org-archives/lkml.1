Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYE2V31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYE2V31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYE2V3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:29:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41063 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYE2V3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:29:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Date: Thu, 29 May 2008 23:29:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>
References: <200805291333.42057.david-b@pacbell.net> <200805292301.42244.rjw@sisk.pl> <200805291426.18404.david-b@pacbell.net>
In-Reply-To: <200805291426.18404.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292329.48896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 of May 2008, David Brownell wrote:
> On Thursday 29 May 2008, Rafael J. Wysocki wrote:
> > Two questions:
> > 
> > 1) How is it related to the analogous patch in the Ingo's tree?
> 
> AFAIK -- just that it's an updated version.  Comments, some
> code flow, but mostly having the "test_suspend=mode" parameter
> default to "safe -- no testing" and allows the choice of modes.
> 
> 
> > 2) Does it apply to the current linux-next?
> 
> No idea.

Could you check, please?  The previous version didn't.

Thanks,
Rafael
