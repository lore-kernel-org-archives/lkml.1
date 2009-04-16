Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbZDQAiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbZDQAiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbZDQAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:33:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519AbZDQAdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:33:49 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.ew.aw85JB@chimera>
Subject: [Bug #13101] BUG: scheduling while atomic: swapper/0/0x10000100
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13101
Subject		: BUG: scheduling while atomic: swapper/0/0x10000100
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-07 7:37 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=123908995822195&w=4


