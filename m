Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbXFQSJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbXFQSJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXFQSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:09:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34024 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXFQSJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:09:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH -mm 0/3] PM: Remove unused and unnecessary features from core suspend code (continued)
Date: Sun, 17 Jun 2007 19:46:25 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <200706150032.21103.rjw@sisk.pl> <20070614231402.GA6317@kroah.com>
In-Reply-To: <20070614231402.GA6317@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171946.26174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The next messages contain the remaining three patches from the previous series
"PM: Remove unused and unnecessary features from suspend and resume core"
that I have promised to resend.

The patches apply to 2.6.22-rc4-mm2, which is particularly important for the
first one, as it is on top of some recent USB changes that right now are
mm-only.  If there are any problems with that, please let me know.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

