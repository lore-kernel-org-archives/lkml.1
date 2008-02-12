Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYBLVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYBLVfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYBLVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:35:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbYBLVfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:35:15 -0500
Date: Tue, 12 Feb 2008 13:34:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Cc: lenb@kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rui.zhang@intel.com
Subject: Re: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]:
 validating input parameters
Message-Id: <20080212133446.a521a8bb.akpm@linux-foundation.org>
In-Reply-To: <05B550FD4BD2014E841D83547B62600802A6B2A7@bgsmsx411.gar.corp.intel.com>
References: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com>
	<20080211133827.16140ba0.akpm@linux-foundation.org>
	<05B550FD4BD2014E841D83547B62600802A6B2A7@bgsmsx411.gar.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 21:27:44 +0530
"Thomas, Sujith" <sujith.thomas@intel.com> wrote:

> > The patch is fairly seriously wordwrapped.
> Should be fixed now.

No, even after I fixed all the wordwrapping I saw a large amount
of fuzz and several rejects when trying to apply the patch.

There's a reason why Len uses his kernel.org account to get real work done ;)
