Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbXJVJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbXJVJ4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXJVJ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:56:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbXJVJ43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:56:29 -0400
Date: Mon, 22 Oct 2007 11:56:25 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13.0.1
Message-ID: <20071022095625.GU6325@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The stable util-linux-ng 2.13.0.1 release is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/


Release Notes
=============

Fixed security issue:
--------------------

 CVE-2007-5191 - mount: doesn't drop privileges properly when calling helpers


Changelog:
---------

 For more details see ChangeLog files at:
 ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.13/


docs:
   - add info about .bugfix releases and branches  [Karel Zak]
mount:
   - doesn't drop privileges properly when calling helpers  [Ludwig Nussel]

-- 
 Karel Zak  <kzak@redhat.com>
