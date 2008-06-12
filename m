Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYFLIhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYFLIhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYFLIgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:36:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36981 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYFLIgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:36:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Remove some obsolete PM stuff
Date: Thu, 12 Jun 2008 10:25:23 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121025.24668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches removes some PM stuff that is obsolete and not
used any more, AFAICS.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

