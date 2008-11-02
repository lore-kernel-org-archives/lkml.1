Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYKBSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYKBSNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYKBSDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:03:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYKBSDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:03:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.tdE.wjeDJB@chimera>
Subject: [Bug #11927] undefined reference to `save_stack_trace'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11927
Subject		: undefined reference to `save_stack_trace'
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-10-31 16:57 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122547246401190&w=4
Handled-By	: Al Viro <viro@zeniv.linux.org.uk>
Patch		: http://marc.info/?l=linux-kernel&m=122548268920986&w=4


