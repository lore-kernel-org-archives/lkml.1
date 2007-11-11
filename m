Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXKKUeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXKKUeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbXKKUeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:34:08 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:32866 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904AbXKKUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:34:07 -0500
Date: Sun, 11 Nov 2007 21:33:13 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Message-ID: <20071111203313.GA18969@electric-eye.fr.zoreil.com>
References: <200711112058.28043.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711112058.28043.rjw@sisk.pl>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki <rjw@sisk.pl> :
> [Note: Due to git.kernel.org not responding I'm unable to check which fixes
> have already been merged since the last report.]
[...]
> Subject	: 2.6.24-rc1 kills onboard r8169 (rtl8111b) NIC
> Submitter	: "Sergey S. Kostyliov" <rathamahata@gmail.com>
> References	: http://lkml.org/lkml/2007/10/28/144
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9257
> Handled-By	: Francois Romieu <romieu@fr.zoreil.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13441&action=view

Fixed and merged in Linus's tree as:
- 50d84c2dc00e48ff9ba018ed0dd23276cf79e566
- b9d04e2401bf308df921d3bbbdacab40fadc27bb

-- 
Ueimor
