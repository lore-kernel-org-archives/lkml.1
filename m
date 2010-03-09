Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0CIPne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:43:34 -0500
Received: from mail-yx0-f191.google.com ([209.85.210.191]:34770 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab0CIPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:43:31 -0500
X-Greylist: delayed 3542 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 10:43:31 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ATZKGRAkdvDf9ax6MXM/Mb0SyQIv4JrEzMLO2s64H1gmMHf9biDG+AeLU+yS5V1mfN
         R7AJBuZzino8ljkJmTAAaRYKUM2R0fg56yM4MRw6Qoivl57r9EKknAD1W4x+iVFRz/nh
         W8ulWWXsNqbFB+CjJKDVj7pILSKXejAdsvdcA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003090941030.28897@router.home>
References: <30859.1268056796@redhat.com> <20100309095830.7d4a744d.kamezawa.hiroyu@jp.fujitsu.com> 
	<8bd0f97a1003081833s2e8527d7pd1e0b427ae76020@mail.gmail.com> 
	<4B9635BE.6090001@petalogix.com> <alpine.DEB.2.00.1003090941030.28897@router.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 10:43:10 -0500
Message-ID: <8bd0f97a1003090743s3635c4ber75258ebadddb0ce9@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix sync_mm_rss in nommu (Was Re: sync_mm_rss() 
	issues
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Michal Simek <michal.simek@petalogix.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 10:41, Christoph Lameter wrote:
> On Tue, 9 Mar 2010, Michal Simek wrote:
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>
> ?? You handled this patch?

pick out the tags from the original patch
-mike
