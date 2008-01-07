Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYAGBZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYAGBZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYAGBZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:25:17 -0500
Received: from ozlabs.org ([203.10.76.45]:49304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYAGBZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:25:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 1/2] show being-loaded/being-unloaded indicator for modules in oopses
Date: Mon, 7 Jan 2008 12:25:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, ak@suse.de, mingo@elte.hu
References: <20080106151850.3eab58b0@laptopd505.fenrus.org>
In-Reply-To: <20080106151850.3eab58b0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071225.04355.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 10:18:50 Arjan van de Ven wrote:
> Subject: show being-loaded/being-unloaded indicator for modules in oopses
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: rusty@rustcorp.com.au
> CC: ak@suse.de
> CC: mingo@elte.hu
>
> It's rather common that an oops/WARN_ON/BUG happens during the load or
> unload of a module. Unfortunatly, it's not always easy to see directly
> which module is being loaded/unloaded from the oops itself. Worse,
> it's not even always possible to ask the bug reporter, since there
> are so many components (udev etc) that auto-load modules that there's
> a good chance that even the reporter doesn't know which module this is.

Excellent, applied.

Thanks Arjan!
Rusty.
