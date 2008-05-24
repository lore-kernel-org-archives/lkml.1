Return-Path: <linux-kernel-owner+w=401wt.eu-S1764733AbYEXVoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733AbYEXVoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbYEXVdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:33:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40165 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761975AbYEXVdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:33:08 -0400
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>, "Len Brown" <lenb@kernel.org>,
       "Pavel Machek" <pavel@suse.cz>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.pzC.2dIOIB@albercik>
Subject: [Bug #10759] recent 2.6.26 kernel hangs at suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10759
Subject		: recent 2.6.26 kernel hangs at suspend
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2008-05-19 15:07 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121121007814338&amp;w=2
Handled-By	: Len Brown <lenb@kernel.org>
		  Pavel Machek <pavel@suse.cz>


