Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbYGCHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbYGCHLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYGCG6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbYGCFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:12:23 -0400
Date: Wed, 2 Jul 2008 22:11:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: inux-next: Tree for July 1
Message-Id: <20080702221132.15a57a72.akpm@linux-foundation.org>
In-Reply-To: <20080702215846.f6b0491b.akpm@linux-foundation.org>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
	<20080702215306.61367733.akpm@linux-foundation.org>
	<20080702215846.f6b0491b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch/s390/appldata/appldata_base.c: In function 'appldata_generic_handler':
arch/s390/appldata/appldata_base.c:393: error: implicit declaration of function 'P_ERROR'

I dunno what that's all about - P_ERROR got deleted but it still has
users.

That's enough s390ing for today...
