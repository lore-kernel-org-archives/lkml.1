Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZDZMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZDZMe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZDZMdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:33:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbZDZMdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:33:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Artem S. Tashkinov" <t.artem@mailcity.com>,
       "Hans Verkuil" <hverkuil@xs4all.nl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.C_C.ipE9JB@chimera>
Subject: [Bug #13003] [2.6.29 regression] ivtv driver causes strange oops'es, disrupts software suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13003
Subject		: [2.6.29 regression] ivtv driver causes strange oops'es, disrupts software suspend
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2009-04-03 14:57 (24 days old)
Handled-By	: Hans Verkuil <hverkuil@xs4all.nl>


