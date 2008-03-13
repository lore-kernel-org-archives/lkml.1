Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYCMMum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYCMMum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCMMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:50:35 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:49912
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYCMMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:50:34 -0400
Date: Thu, 13 Mar 2008 13:50:16 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Message-ID: <20080313125016.GZ7365@v2.random>
References: <200803130214.36861.lenb@kernel.org> <20080312234516.bb079cc5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312234516.bb079cc5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 11:45:16PM -0700, Andrew Morton wrote:
> http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch
> 
>   Hopeully fix a regression which Andrea Arcangeli hit.  Although I'm not sure
>   that he has confirmed that this revert actually works?

Last time I tried it fixed my boot failure (I found it by bisecting).

Thanks.
