Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXCYVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXCYVzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXCYVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 17:55:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59332 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbXCYVzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 17:55:37 -0400
Date: Sun, 25 Mar 2007 13:50:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, torvalds@linux-foundation.org,
       "John Stultz" <johnstul@us.ibm.com>
Subject: Re: apm.c: get rid of unused variables
Message-Id: <20070325135029.77109148.akpm@linux-foundation.org>
In-Reply-To: <82e4877d0703251007p390f4ed5g850dc5014fbeb66b@mail.gmail.com>
References: <Pine.LNX.4.64.0703251158400.17623@paragw-desktop>
	<20070325162505.GN16477@stusta.de>
	<82e4877d0703251007p390f4ed5g850dc5014fbeb66b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 13:07:41 -0400 "Parag Warudkar" <parag.warudkar@gmail.com> wrote:

> Separate Kconfig patch below and also attached.

Please avoid sending two copies of a patch in the same email like this.

Because the result applies happily with `patch --dry-run' then makes a mess
when you try to apply it for real.
