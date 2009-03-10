Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZCJNZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZCJNZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZCJNZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:25:05 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:49702 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZCJNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:25:04 -0400
Subject: Re: [PATCH 01/25] [btrfs] BUG to BUG_ON changes
From: Chris Mason <chris.mason@oracle.com>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
	 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 09:24:55 -0400
Message-Id: <1236691495.23800.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49B66A2A.030E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 00:10 -0500, Stoyan Gaydarov wrote:
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  fs/btrfs/ctree.c            |    3 +--
>  fs/btrfs/extent-tree.c      |    3 +--
>  fs/btrfs/free-space-cache.c |    3 +--
>  fs/btrfs/tree-log.c         |    3 +--
>  4 files changed, 4 insertions(+), 8 deletions(-)
> 

Thanks, I've queued this one up.

-chris


