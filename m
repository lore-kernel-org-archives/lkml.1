Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXICS1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXICS1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXICS1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:27:06 -0400
Received: from [212.12.190.46] ([212.12.190.46]:32860 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754683AbXICS05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:26:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [GIT PULL -mm] Unionfs/fsstack/eCryptfs updates/cleanups/fixes
Date: Mon, 3 Sep 2007 21:26:47 +0300
User-Agent: KMail/1.5
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de
References: <200709031618.l83GIfsU005109@agora.fsl.cs.sunysb.edu>
In-Reply-To: <200709031618.l83GIfsU005109@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709032126.47232.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> Al, we have back-ports of the latest Unionfs to 2.6.{22,21,20,19,18,9},
> all in http://unionfs.filesystems.org/.  Before we release any change, we
> test it on all back-ports as well as the latest -rc/-mm code base (takes
> over 24 hours straight to get through all of our regressions :-)

I am impressed, thanks!

It's probably a good idea to always point these backports out, whenever 
submitting patches against -mm.  Otherwise, people might forget.

> So we'd be happy to submit those patches to the latest stable kernel. 
> But, are you talking about VFS/ecryptfs patches (which are in the stable
> kernel), or are you talking about Unionfs (which is not)?

I'm talking about Unionfs, which seems like a rather critical feature to 
miss-out on.  BTW, did you ever get that oops-on-umount worked out?


Thanks!

--
Al

