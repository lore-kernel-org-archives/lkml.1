Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZI2XiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZI2XiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZI2XiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:38:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZI2XiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:38:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 2.6.32-rc2: wlan rt73 dead
Date: Wed, 30 Sep 2009 01:39:05 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
References: <20090929170615.GA5539@fancy-poultry.org> <20090929200413.GA5950@fancy-poultry.org> <1254267140.3959.1.camel@johannes.local>
In-Reply-To: <1254267140.3959.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909300139.06019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Johannes Berg wrote:
> On Tue, 2009-09-29 at 22:04 +0200, Heinz Diehl wrote:
> > On 29.09.2009, John W. Linville wrote: 
> > 
> > > Could you do a git bisect?
> > 
> > I have never used git in my whole life, but I'll read the documentation
> > and try.
> 
> While it's a good skill, don't waste your time. You're running opensuse,
> I suppose, and having the same problem as Hugh:
> http://bugzilla.kernel.org/show_bug.cgi?id=14263
> 
> Rafael: I'm pretty sure this (14272) is a dupe of 14263.

Thanks, marked as a duplicate and closed.

Rafael
