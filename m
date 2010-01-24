Return-Path: <linux-kernel-owner+w=401wt.eu-S1751628Ab0AXXDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0AXXDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201Ab0AXXDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:03:19 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:43078 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0AXXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:03:19 -0500
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 18:03:18 EST
Date: Sun, 24 Jan 2010 23:43:30 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #15025] Oops in ext4 driver
Message-ID: <20100124224330.GA2230@uio.no>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <hE3x9c-4KZM.A.IRG.kKMXLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <hE3x9c-4KZM.A.IRG.kKMXLB@chimera>
X-Operating-System: Linux 2.6.29.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 11:04:35PM +0100, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

I'm not using 2.6.33 anymore since this bug is a showstopper to me (it's on a
production system), so I'm unable to check if it's fixed or not.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
