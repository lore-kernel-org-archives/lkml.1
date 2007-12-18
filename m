Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbXLRKFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbXLRKFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXLRKFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:05:04 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:27777 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXLRKFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:05:01 -0500
Subject: Re: [PATCH] arch/s390/: Spelling fixes
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       linux390@de.ibm.com
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 18 Dec 2007 11:04:58 +0100
Message-Id: <1197972298.13237.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,
I've added all three spelling fix patches to the git390. The patch for
drivers lost one hunk because there is another patch in the git390 tree
that removes the comment you are trying to fix. Your patches will be
included in the big merge frenzy after 2.6.24 has been released.
Thanks.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


