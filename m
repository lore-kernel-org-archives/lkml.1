Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYABDZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYABDZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYABDZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:25:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:24653 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbYABDZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:25:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,231,1196668800"; 
   d="scan'208";a="476394225"
Date: Wed, 2 Jan 2008 11:12:05 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Message-ID: <20080102031205.GA10794@zhen-devel.sh.intel.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <200801012202.57851.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801012202.57851.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.23 i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.01.01 22:02:57 +0000, Rafael J. Wysocki wrote:
> Subject		: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
> Submitter	: Harald Welte <laforge@gnumonks.org>
> Date		: 2007-12-22 04:37
> References	: http://lkml.org/lkml/2007/12/21/269
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9618
> Handled-By	: Zhenyu Wang <zhen78@gmail.com>
> Patch		: 

This is resolved by turning on CONFIG_DMAR_GFX_WA.

