Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZFHLNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZFHLNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZFHLNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:13:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbZFHLNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:13:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13306] hibernate slow on _second_ run
Date: Mon, 8 Jun 2009 13:14:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.u-H.Ra7KKB@chimera> <1244442961.11457.0.camel@johannes.local>
In-Reply-To: <1244442961.11457.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081314.04356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Johannes Berg wrote:
> On Sun, 2009-06-07 at 11:52 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13306
> > Subject		: hibernate slow on _second_ run
> > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > Date		: 2009-05-14 09:34 (25 days old)
> 
> I'm still seeing this, did you get a chance to look at the ftrace?

It's on my todo list, really close to the top.  Will do later today.

Best,
Rafael
