Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKLRDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKLRDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZKLRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:03:08 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43245 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZKLRDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:03:07 -0500
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Date: Thu, 12 Nov 2009 10:02:59 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: build issue #34 for v2.6.32-rc6-346-gaa021ba :ERROR:
 "log_start_commit" [fs/ext3/ext3.ko] undefined!
In-reply-to: <200911121756.25718.toralf.foerster@gmx.de>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ext4 development <linux-ext4@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Message-id: <04B31A2B-6807-4B71-A3CB-997E611C765B@sun.com>
X-Mailer: Apple Mail (2.936)
Content-transfer-encoding: 8BIT
References: <200911121756.25718.toralf.foerster@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-11-12, at 09:56, Toralf Förster wrote:
> the build (.config attached) failed, make ends with :
> ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2


A fix has already been submitted upstream for this, please see
the list archives.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

