Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYESLYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYESLYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 07:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYESLYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 07:24:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbYESLYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 07:24:08 -0400
Date: Mon, 19 May 2008 13:24:02 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.14-rc3
Message-ID: <20080519112402.GF17439@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The third util-linux-ng 2.14 release candidate is available at

   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.14/


Feedback and bug reports, as always, are welcomed.

       Karel


v2.14-rc3 changelog:
~~~~~~~~~~~~~~~~~~~

build-sys:
   - add support ionice for Super-H architecture  [Karel Zak]
docs:
   - we already rewrote the scriptreplay script; remove that TODO entry  [James Youngman]
fdisk:
   - doesn't recognize the VMware ESX partitions  [Karel Zak]
mount:
   - remount doesn't care about loop=  [Karel Zak]
po:
   - update cs.po (from translationproject.org)  [Petr Pisar]
   - update it.po (from translationproject.org)  [Marco Colombo]
   - update nl.po (from translationproject.org)  [Benno Schulenberg]
   - update vi.po (from translationproject.org)  [Clytie Siddall]
setarch:
   - add fallback for linux/personality  [Karel Zak]

-- 
 Karel Zak  <kzak@redhat.com>
