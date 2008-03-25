Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYCYTs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYCYTs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYCYTss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:48:48 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:36111 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYCYTsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:48:47 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Introduce new top level =?iso-8859-1?q?suspend=09and_hibernation_callbacks?= (rev. 2)
Date: Tue, 25 Mar 2008 20:48:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803251030220.4838-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803251030220.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803252048.43792.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. März 2008 15:33:22 schrieb Alan Stern:
> > so I'd say a
> > failure to resume is just a limited subcase of a device vanishing during
> > sleep.
> 
> I'll go along with that.  If a device vanishes during sleep, the PM 
> core isn't responsible for unregistering it -- the device's subsystem 
> is.

Yes, that makes sense. You are right.

	Regards
		Oliver

