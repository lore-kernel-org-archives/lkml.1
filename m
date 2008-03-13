Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbYCMWze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYCMWze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbYCMWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:55:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbYCMWzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:55:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] PM: Remove legacy PM
Date: Thu, 13 Mar 2008 23:51:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132351.19794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The first of the following two patches removes the legacy PM infrastructure
and the second one removes some of its remnants from the MIPS tree.

Please add them to the suspend branch.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

