Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXFKPAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXFKPAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXFKPAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:00:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXFKPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:00:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 0/7] PM: Remove unused and unnecessary features from suspend and resume core
Date: Mon, 11 Jun 2007 16:55:49 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111655.50022.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches removes some unused and unnecessary features
from the suspend and resume core code.

Comments welcome.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

