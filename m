Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZFGM5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZFGM5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZFGMyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:54:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbZFGMyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:54:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
In-Reply-To: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <D9VoutSOyXP.A.1CH.VZ7KKB@chimera>
Subject: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Jun 2009 11:52:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
Subject		: Warning 'Invalid throttling state, reset' gets displayed when it should not be
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-05-26 15:24 (13 days old)
Handled-By	: Frans Pop <elendil@planet.nl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
		  http://bugzilla.kernel.org/attachment.cgi?id=21672


