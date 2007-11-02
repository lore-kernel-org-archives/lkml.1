Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXKBKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXKBKri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXKBKrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:47:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXKBKrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:47:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [linux-pm] [RFC][PATCH 1/3] Suspend: Testing facility
Date: Fri, 2 Nov 2007 12:04:10 +0100
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200711012357.27797.rjw@sisk.pl> <200711012358.27919.rjw@sisk.pl> <1193999626.25744.5.camel@johannes.berg>
In-Reply-To: <1193999626.25744.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021204.11093.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 2 November 2007 11:33, Johannes Berg wrote:
> 
> > 5 - test the freezing of processes
> 
> > +/* Suspend test levels */
> > +enum {
> > +	TEST_NONE,
> 
> Without reading the code, I assume that this enum controls those levels.
> I think a comment that it is user-space visible API and should not be
> reordered would be warranted.

Yes, you are right.  I'll add the comment.

Thanks,
Rafael
