Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbZCaCo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbZCaCo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZCaCoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:44:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbZCaCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=meEfwxb5mFzC08JqS+1Io8A6gfRLOCVbZw7EhslDfEmwURc6EuT1WKoabxVuz0IHu7
         09FU2VFVTIJJ2QckPA0Zl4bZPCrifQsxGO1+AZmeoNIml0khMbNq+KLqWuR79PsYMJJ8
         WxJWLtz2Op8nP5KUFaiTC/UHj+UC/AQdlyqL4=
MIME-Version: 1.0
In-Reply-To: <20090330163619.d08ba85e.akpm@linux-foundation.org>
References: <ea11fea30903222039r4bec470crfd9825e37a926d56@mail.gmail.com> 
	<20090330163619.d08ba85e.akpm@linux-foundation.org>
Date: Tue, 31 Mar 2009 08:13:56 +0530
Message-ID: <ea11fea30903301943m34a04f08hc4251c6a6039e97@mail.gmail.com>
Subject: Re: [PATCH] : Code cleanup for fs/inode.c as per checkpatch.pl
From: Manish Katiyar <mkatiyar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 5:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 23 Mar 2009 09:09:26 +0530
> Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>> Code cleanup for fs/inode.c as per checkpatch.pl
>> Before:
>> total: 24 errors, 25 warnings, 1546 lines checked
>> After:
>> total: 0 errors, 0 warnings, 1539 lines checked
>
> Probably OK, but again, please cc linux-kernel and/or linx-fsdevel.

Hi Andrew,

[ cced lkml ]

Thanks -
Manish
>
> Also, your email client wordwrapped the patch.
>
