Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZGWXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZGWXpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZGWXpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:45:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZGWXpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:45:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Regression] kdesu broken
Date: Fri, 24 Jul 2009 01:45:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907240145.31935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
discussion about that, but I can't find it right now.  Any clues?

Rafael
