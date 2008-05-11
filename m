Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYEKVOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYEKVOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYEKVB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbYEKVBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:50 -0400
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Paulo Marques" <pmarques@grupopie.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.lJG.bv1JIB@chimera>
Subject: [Bug #10674] /proc/kallsyms broken in 2.6.26-rc1-git6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10674
Subject		: /proc/kallsyms broken in 2.6.26-rc1-git6
Submitter	: Andi Kleen <andi@firstfloor.org>
Date		: 2008-05-09 17:41 (3 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121035508420184&amp;w=4
Handled-By	: Paulo Marques <pmarques@grupopie.com>
		  Alexey Dobriyan <adobriyan@gmail.com>


