Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZHZAHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZHZAHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbZHZAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:07:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378AbZHZAFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:05:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Kurt Roeckx" <kurt@roeckx.be>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Cg6cQYLdUxG.A.8lB.Q0GlKB@chimera>
Subject: [Bug #13780] NULL pointer dereference loading powernowk8
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
Subject		: NULL pointer dereference loading powernowk8
Submitter	: Kurt Roeckx <kurt@roeckx.be>
Date		: 2009-07-15 18:00 (42 days old)


