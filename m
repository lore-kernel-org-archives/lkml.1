Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZDZMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZDZMli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbZDZMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:34:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43875 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbZDZMeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:34:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, "Bart" <mmx@riz.pl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.KjC.JpE9JB@chimera>
Subject: [Bug #13112] Oops in drain_array
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13112
Subject		: Oops in drain_array
Submitter	: Bart <mmx@riz.pl>
Date		: 2009-04-14 10:21 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123970493224628&w=4


