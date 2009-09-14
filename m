Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZINPGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZINPGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZINPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:06:52 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:36042 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZINPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:06:51 -0400
Date: Tue, 15 Sep 2009 00:06:54 +0900 (JST)
Message-Id: <20090915.000654.193698133.ryov@valinux.co.jp>
To: dwalker@fifo99.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@redhat.com
Subject: Re: [PATCH 1/9] I/O bandwidth controller and BIO tracking
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <1252937480.28368.221.camel@desktop>
References: <20090914.212805.193688121.ryov@valinux.co.jp>
	<1252937480.28368.221.camel@desktop>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Daniel Walker <dwalker@fifo99.com> wrote:
> On Mon, 2009-09-14 at 21:28 +0900, Ryo Tsuruta wrote:
> 
> > The list of the patches:
> >   [PATCH 1/9] I/O bandwidth controller and BIO tracking
> >   [PATCH 2/9] dm-ioband-1.13.0: All-in-one patch
> >   [PATCH 3/9] blkio-cgroup-v12: The new page_cgroup framework
> >   [PATCH 4/9] blkio-cgroup-v12: Refactoring io-context initialization
> >   [PATCH 5/9] blkio-cgroup-v12: The body of blkio-cgroup
> >   [PATCH 6/9] blkio-cgroup-v12: Page tracking hooks
> >   [PATCH 7/9] blkio-cgroup-v12: The document of blkio-cgroup
> >   [PATCH 8/9] blkio-cgroup-v12: Add a cgroup support to dm-ioband
> >   [PATCH 9/9] blkio-cgroup-v12: The document of a cgroup support for dm-ioband
> 
> 
> Patches 5, 8, and 9 all have checkpatch errors (2 does also but it
> involves tracing, so Steven may not let you fix them). 
> 
> Could you correct those errors before this get included ?

Thank you for checking the patches, I'll fix them by the next post.

Thanks,
Ryo Tsuruta
