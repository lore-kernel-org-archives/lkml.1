Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbXJHTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbXJHTwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXJHTv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:51:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbXJHTv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:51:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc9-git5: Known regressions from 2.6.22
Date: Mon, 8 Oct 2007 22:07:02 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710072202.34621.rjw@sisk.pl> <470A6EA5.20704@redhat.com>
In-Reply-To: <470A6EA5.20704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710082207.03237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 October 2007 19:53, Chuck Ebbert wrote:
> On 10/07/2007 04:02 PM, Rafael J. Wysocki wrote:
> > This message contains a list of some known regressions from 2.6.22 for which
> > there are no fixes in the mainline that I know of.  If any of them have been fixed
> > already, please let me know.
> > 
> > If you know of any other unresolved regressions from 2.6.22, please let me know
> > either and I'll add them to the list.
> > 
> 
> "top displaying 9999% CPU usage"
> 
> Report:
> http://lkml.org/lkml/2007/10/3/123
> 
> Fix, reverting to imprecise time accounting:
> http://lkml.org/lkml/2007/10/4/389

Added: http://bugzilla.kernel.org/show_bug.cgi?id=9135

Thanks,
Rafael
