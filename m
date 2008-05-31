Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYEaS5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYEaS5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYEaSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51432 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbYEaSvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:33 -0400
Cc: "Amit Shah" <shahamit@gmail.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.ugE.trZQIB@albercik>
Subject: [Bug #10748] dhclient fails to run; capabilities error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10748
Subject		: dhclient fails to run; capabilities error
Submitter	: Amit Shah <shahamit@gmail.com>
Date		: 2008-05-19 06:25 (13 days old)


