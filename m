Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYCLAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYCLAC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYCLACi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:02:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37139 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYCLACh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:02:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 0/3] PM core fixes
Date: Wed, 12 Mar 2008 00:55:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120055.25885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The following series of patches contains some fixes of the PM core related to
the suspending and resuming of devices.  All of the details are (hopefully)
described in the patches' changelogs.

These patches are targeted at 2.6.26, but we (the authors) would like them to
get as much linux-next and -mm testing as possible, so please add them to your
queue.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

