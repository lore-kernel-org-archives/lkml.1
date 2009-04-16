Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZDQAkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZDQAkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759542AbZDQAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759562AbZDQAeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, "Bart" <mmx@riz.pl>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.U4H.Qw85JB@chimera>
Subject: [Bug #13112] Oops in drain_array
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
Subject		: Oops in drain_array
Submitter	: Bart <mmx@riz.pl>
Date		: 2009-04-14 10:21 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4


