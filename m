Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbYD1Mnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbYD1Mnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765374AbYD1Mnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:43:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765110AbYD1Mnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:43:39 -0400
Date: Mon, 28 Apr 2008 14:43:36 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng v2.14-rc2
Message-ID: <20080428124336.GJ3249@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The second util-linux-ng 2.14 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/


Feedback and bug reports, as always, are welcomed.

       Karel


v2.14-rc2 changelog:
~~~~~~~~~~~~~~~~~~~

build-sys:
   - release++  [Karel Zak]
docs:
   - update v2.14 ReleaseNotes  [Karel Zak]
ionice:
   - update man page to reflect IDLE class change in  2.6.25  [Karel Zak]
login:
   - audit log injection attack via login  [Steve Grubb]
po:
   - merge changes  [Karel Zak]
scriptreplay:
   - gettextize a forgotten messages  [Karel Zak]

-- 
 Karel Zak  <kzak@redhat.com>
