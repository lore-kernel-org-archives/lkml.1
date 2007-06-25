Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXFYWDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXFYWDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXFYWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:02:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbXFYWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:02:54 -0400
Date: Mon, 25 Jun 2007 15:01:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-Id: <20070625150127.3a45f66d.akpm@linux-foundation.org>
In-Reply-To: <200706251434.43863.jesse.barnes@intel.com>
References: <200706251434.43863.jesse.barnes@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 14:34:42 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> akpm -- this one should replace all the mtrr patches currently
> in your tree.

fear, uncertainty, doubt.

box:/usr/src/25> grep mtrr series 
x86_64-mm-bug-in-i386-mtrr-initialization.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix.patch
i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix-2.patch
i386-mtrr-clean-up-usage_table.patch

Not all of those, I'm sure.  I think you're referring to the final
four.  I guess if it doesn't compile (again) I'll find out ;)
