Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXE3UPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXE3UPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXE3UPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:15:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1821 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbXE3UPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eLKYlLoyvb7XoR8PXNFXHvHgYOv/atwGc4N9+0KajtTgsvfCWjJ2tJWtUHb5OOxrZvP/z5oDbAnC8/jbQwQ3BO3Fd0rAhaTWq1Ryucn4HHKh7hFiP3RN+wIOKJ6OBfDuYadVt6giBuW3ZRPHQNCEQWs8mN1v3u+vzzBECN66Lhg=
Message-ID: <465DDB65.90207@gmail.com>
Date: Wed, 30 May 2007 21:15:33 +0100
From: Michael-Luke Jones <mike.luke.jones@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [-mm] Move zlib compression library to common directory [TAKE
 TWO]
References: <465C3973.3090303@gmail.com>	<465C5549.4050101@gmail.com> <20070530104747.41b4995f.akpm@linux-foundation.org>
In-Reply-To: <20070530104747.41b4995f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Lots of git goodies there - I didn't actually receive the patch: the parts
> which move files around were communicated via git metadata, not diffs.
> Presumably there's a way to tell git to not do that.
> 
> But probably it's best that this change be merged via git anyway.  David,
> are you interested in handling it?

Update: totally ignore this patch. Even using git-apply something gets
confused and git loses the meaning of the renames, turning them into
file additions and deletions.

A better version will no doubt come along. In the mean time, it looks
like I need to improve my git-foo skills...

M-L
