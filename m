Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZF1Vxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZF1Vxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZF1Vxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:53:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZF1Vxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:53:47 -0400
Date: Sun, 28 Jun 2009 14:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using
 pipes in core_pattern
Message-Id: <20090628145228.2f80f327.akpm@linux-foundation.org>
In-Reply-To: <m163egt524.fsf@fess.ebiederm.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
	<20090628135235.10f9b153.akpm@linux-foundation.org>
	<m163egt524.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 14:35:31 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew should I toss all 100 or so patches over the wall to you
> and your -mm tree?  Or should I maintain a public git tree based
> at 2.6.31-rc1?  Get it into linux-next and ask Linus to pull it when
> the merge window comes?

The latter would be more convenient for me.  It may cause pain for
yourself and Stephen though?

