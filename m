Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZHZAHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZHZAHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZHZAHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:07:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbZHZAFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:05:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Jiri Kosina" <jkosina@suse.cz>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Cg6cQYLdUxG.A.etB.T0GlKB@chimera>
Subject: [Bug #13739] 2.6.30 leaking keys on console switch
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 23:05:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13739
Subject		: 2.6.30 leaking keys on console switch
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2009-07-07 8:44 (50 days old)
References	: http://marc.info/?l=linux-kernel&m=124695628924382&w=4
Handled-By	: Jiri Kosina <jkosina@suse.cz>


