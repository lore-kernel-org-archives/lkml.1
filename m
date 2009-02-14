Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZBNXPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZBNXPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZBNXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:07:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbZBNXHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:49 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.H6D.Yr0lJB@chimera>
Subject: [Bug #12671] uvc_status_cleanup(): undefined reference to `input_unregister_device'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12671
Subject		: uvc_status_cleanup(): undefined reference to `input_unregister_device'
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-02-08 14:58 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123410529909318&w=4


