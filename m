Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYG3Drm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYG3Drm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 23:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYG3Dre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 23:47:34 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51680 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYG3Dre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 23:47:34 -0400
Date: Tue, 29 Jul 2008 23:43:59 -0400
Message-Id: <200807300343.m6U3hxuA013627@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bharata@linux.vnet.ibm.com
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Unionfs] Re: [PATCH -mm] unionfs: build fixes 
In-reply-to: Your message of "Wed, 30 Jul 2008 08:57:38 +0530."
             <20080730032738.GA3977@in.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080730032738.GA3977@in.ibm.com>, Bharata B Rao writes:
> On Tue, Jul 29, 2008 at 09:02:03PM -0400, Erez Zadok wrote:
[...]

> When I last checked, David Woodhouse/Jan Blunck were working on this.
> Looks like they have become busy with other work now. I can take that work
> forward.

Now that I've restructured and refactored the whiteout code in unionfs, I
can easily be your Guinea pig. :-)

Thanks,
Erez.
