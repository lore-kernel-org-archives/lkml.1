Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXIOPOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXIOPOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXIOPNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:13:55 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:62200 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbXIOPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:13:54 -0400
X-Greylist: delayed 3167 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 11:13:54 EDT
Date: Sat, 15 Sep 2007 10:20:55 -0400
From: Eric Cooper <ecc@cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tx tox <t0mc4t1@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: boot hangs with SMP, USB storage, and ACPI
Message-ID: <20070915142055.GA3983@stratocaster.home>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	tx tox <t0mc4t1@gmail.com>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <9b9c8e900709120600n3ffa9b6fn1bd514672d2e9bc1@mail.gmail.com> <20070915025208.acb03ad3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915025208.acb03ad3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 02:52:08AM -0700, Andrew Morton wrote:
> Could you both please test 2.6.22 (or 2.6.23, soon) and if the bug is still
> present, raise a report against acpi at bugzilla.kernel.org?
> 
> We'd be particularly internested in knowing if any earlier 2.6 kernel
> worked OK and if so, which version(s).

I tried this with prebuilt Debian package linux-image-2.6.21-2-686
from "testing" and linux-image-2.6.22-2-686 from "unstable".

The problem is still present in both versions.  Will file a bugzilla
report as requested.

-- 
Eric Cooper             e c c @ c m u . e d u
