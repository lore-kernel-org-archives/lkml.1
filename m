Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYBRKSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYBRKSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbYBRKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:18:07 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39369 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757293AbYBRKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:18:04 -0500
Date: Mon, 18 Feb 2008 15:47:34 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       lenb@kernel.org, yakui.zhao@intel.com, csnook@redhat.com
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080218101734.GA6348@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200802172304.00322.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802172304.00322.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9982
> Subject		: 2.6.25-rc1 panics on boot
> Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Date		: 2008-02-13 18:03
> References	: http://lkml.org/lkml/2008/2/13/363
> Handled-By	: Chris Snook <csnook@redhat.com>

Hi Rafael,

A fix was proposed and accepted at
http://bugzilla.kernel.org/attachment.cgi?id=14832&action=view .

The bug has been marked as resolved. (You might want to modify your
script to handle such cases.)

-- 
regards,
Dhaval
