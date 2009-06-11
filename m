Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZFKKGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZFKKGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbZFKKFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:05:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43200 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZFKKFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YwhU+Resp2LdnHp+wftTMo+T2NojxG3ffP8npUmX5ZYRnrQHIfatoAssK8z3f0RC4g
         EYL1hr/zSYTpnwJlTv4jwjTUzxLtrNiK39uJJCCcBItVsP4ajbelxpr2+hhwqJBx0mvk
         Deq9kdGV97BilZSLT3YP2vs/Z7aovsljC2j7Y=
MIME-Version: 1.0
In-Reply-To: <20090609221157.921c014d.akpm@linux-foundation.org>
References: <38b2ab8a0906080028h7a0e3ba2i80a98dcee67b5662@mail.gmail.com>
	 <20090609221157.921c014d.akpm@linux-foundation.org>
Date: Thu, 11 Jun 2009 12:05:55 +0200
Message-ID: <38b2ab8a0906110305y1da1e985n5b3c0b6c827a537f@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at NULL 
	while resuming
From: Francis Moreau <francis.moro@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 10, 2009 at 7:11 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Mon, 8 Jun 2009 09:28:18 +0200 Francis Moreau <francis.moro@gmail.com> wrote:
>
> The trace is the same as the one reported by Daniel in the thread
> titled "BUG: NULL pointer dereference in try_to_del_timer_sync()",
> started April 28.
>
> Alan's patch (below) is in mainline and appears to be lined up for the
> next 2.5.29.x release.

Ok, I'll upgrade to 2.6.30 soon.

thanks
-- 
Francis
