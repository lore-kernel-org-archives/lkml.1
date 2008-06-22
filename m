Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbYFVWV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbYFVWV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYFVWVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:21:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbYFVWVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:21:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] PM: Remove obsolete and drop unnecessary includes
Date: Mon, 23 Jun 2008 00:19:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230019.41016.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first of the following two patches drops some outdated documentation and
the other drops unnecessary includes from include/linux/pm.h .

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

