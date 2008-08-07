Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYHGMap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYHGMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYHGMaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:30:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:58484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbYHGMaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,319,1215414000"; 
   d="scan'208";a="604728847"
Subject: [PATCH 0/6] kexec jump: fixes for 2.6.27
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 17:05:20 +0800
Message-Id: <1218099920.5164.31.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes some issues of kexec jump for 2.6.27.

It is based on 2.6.27-rc2 and has been tested on i386 platform.

Best Regards,
Huang Ying


