Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXKDNAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXKDNAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbXKDNAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:00:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbXKDNAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:00:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: *SPAM* Re: 2.6.24-rc1: OOPS at  acpi_battery_update
Date: Sun, 4 Nov 2007 14:17:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <1193652664.22149.4.camel@localhost> <200711021708.42370.rjw@sisk.pl> <1194168853.10245.18.camel@rukbat>
In-Reply-To: <1194168853.10245.18.camel@rukbat>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711041417.23920.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 of November 2007, Romano Giannetti wrote:
> 
> On Fri, 2007-11-02 at 17:08 +0100, Rafael J. Wysocki wrote:
> > On Friday, 2 November 2007 00:14, Andrew Morton wrote:
> > > On Mon, 29 Oct 2007 11:11:04 +0100
> [OOPS removed]
> > > 
> > > Did any earlier kernels do this?  In other words, do you believe that this
> > > is a bug which we added after 2.6.23 was released?
> 
> Never noticed it before. But it's happening just sometime (I've had it
> just two times), so I cannot be sure.
> 
> > This might be the same as http://bugzilla.kernel.org/show_bug.cgi?id=9283
> 
> Hmmm... there is too little info for my level in that bug report to
> understand if it's the same. 

Then, please apply the patch from

http://bugzilla.kernel.org/attachment.cgi?id=13376&action=view

and see if the problem goes away.
