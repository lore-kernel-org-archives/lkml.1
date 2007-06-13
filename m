Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXFMV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXFMV3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXFMV3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXFMV3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/7] PM: Remove unused and unnecessary features from suspend and resume core
Date: Wed, 13 Jun 2007 15:51:48 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131551.51336.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches removes some unused and unnecessary features
from the suspend and resume core code.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

