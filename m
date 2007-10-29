Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXJ2Xcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXJ2Xcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXJ2Xcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:32:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbXJ2Xce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:32:34 -0400
Date: Mon, 29 Oct 2007 19:32:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: 32bit builds on x86-64 host.
Message-ID: <20071029233231.GI7793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Before the arch merge, I frequently would test 32bit compiles
by doing make ARCH=i386 {bzImage/modules/file.o}

Since commit 47572387d58a9584c60ebbbdee56fc92c627f16f
how does one do this?

	Dave

-- 
http://www.codemonkey.org.uk
