Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbYCNA3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbYCNA3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYCNA3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:29:00 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:55764
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYCNA27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:28:59 -0400
Date: Fri, 14 Mar 2008 01:28:57 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Message-ID: <20080314002857.GO7365@v2.random>
References: <200803130214.36861.lenb@kernel.org> <20080312234516.bb079cc5.akpm@linux-foundation.org> <20080313125016.GZ7365@v2.random> <200803131349.27964.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803131349.27964.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 01:49:27PM -0400, Len Brown wrote:
> or check out Linus' top of tree and apply the plain patch:
> ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.25/acpi-release-20070126-2.6.25-rc5.diff.gz

This fixed my problem thanks.
