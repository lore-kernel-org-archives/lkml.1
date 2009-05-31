Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZEaJgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZEaJgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 05:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZEaJgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 05:36:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZEaJgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 05:36:21 -0400
Message-ID: <4A224F94.1050107@redhat.com>
Date: Sun, 31 May 2009 12:36:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [PATCH 0/2] kvm: validate irqfd type
References: <4A1D48FA.9080403@novell.com> <20090527143251.14024.89090.stgit@dev.haskins.net>
In-Reply-To: <20090527143251.14024.89090.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Michael Tsirkin pointed out an issue in kvm.git w.r.t. malicious userspace
> configuring irqfd objects:
>
> http://lkml.org/lkml/2009/5/27/341
>
> This series applies to kvm.git/master:1a6a35a1 to attempt to close the
> vulnerability.
>
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

