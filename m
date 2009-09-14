Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZINOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZINOKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZINOKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:10:40 -0400
Received: from fifo99.com ([67.223.236.141]:59426 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZINOKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:10:40 -0400
Subject: Re: [PATCH 1/9] I/O bandwidth controller and BIO tracking
From: Daniel Walker <dwalker@fifo99.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@redhat.com
In-Reply-To: <20090914.212805.193688121.ryov@valinux.co.jp>
References: <20090914.212805.193688121.ryov@valinux.co.jp>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 07:11:20 -0700
Message-Id: <1252937480.28368.221.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 21:28 +0900, Ryo Tsuruta wrote:

> The list of the patches:
>   [PATCH 1/9] I/O bandwidth controller and BIO tracking
>   [PATCH 2/9] dm-ioband-1.13.0: All-in-one patch
>   [PATCH 3/9] blkio-cgroup-v12: The new page_cgroup framework
>   [PATCH 4/9] blkio-cgroup-v12: Refactoring io-context initialization
>   [PATCH 5/9] blkio-cgroup-v12: The body of blkio-cgroup
>   [PATCH 6/9] blkio-cgroup-v12: Page tracking hooks
>   [PATCH 7/9] blkio-cgroup-v12: The document of blkio-cgroup
>   [PATCH 8/9] blkio-cgroup-v12: Add a cgroup support to dm-ioband
>   [PATCH 9/9] blkio-cgroup-v12: The document of a cgroup support for dm-ioband


Patches 5, 8, and 9 all have checkpatch errors (2 does also but it
involves tracing, so Steven may not let you fix them). 

Could you correct those errors before this get included ?

Daniel

