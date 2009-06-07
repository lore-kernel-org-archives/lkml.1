Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZFGM7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZFGM7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZFGMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:55:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbZFGMy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:54:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Iob" <andrea_iob@yahoo.it>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.ScG.FZ7KKB@chimera>
Subject: [Bug #13446] resume after suspend-to-ram broken on Toshiba Satellite A100 with 2.6.30-rc8 (works in 2.6.28)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13446
Subject		: resume after suspend-to-ram broken on Toshiba Satellite A100 with 2.6.30-rc8 (works in 2.6.28)
Submitter	: Andrea Iob <andrea_iob@yahoo.it>
Date		: 2009-06-03 21:42 (5 days old)


