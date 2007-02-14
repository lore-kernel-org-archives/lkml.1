Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbXBNIuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbXBNIuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXBNIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:50:24 -0500
Received: from smtp.nokia.com ([131.228.20.171]:21878 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXBNIuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:50:23 -0500
Subject: Re: Pull UBI tree
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Arnez <arnez@vnet.ibm.com>,
       Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20070213160849.GB22748@infradead.org>
References: <1171380852.17314.55.camel@sauron>
	 <20070213160849.GB22748@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 14 Feb 2007 10:46:04 +0200
Message-Id: <1171442764.17314.87.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Feb 2007 08:45:35.0385 (UTC) FILETIME=[7E6AE090:01C75014]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070214104406-3DBFEBB0-099A7F4E/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 16:08 +0000, Christoph Hellwig wrote:
> Please send out a current version for review instead.  Last time I looked
> at it lots of things looked quite over-engineered, and I'd like to check
> if this has been improved since.

The patch is big and LKML does filtered the mail. Actually the one in
-mm tree is almost the latest version, it is OK to look at it as we did
not do large changes.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

