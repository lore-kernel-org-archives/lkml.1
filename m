Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZKLSGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZKLSGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZKLSGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:06:04 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40470 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbZKLSGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:06:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F4ent9LA/a6oq2s+wuRKzPQGBKSYOpCCKcgEjYBenLseGR5BVJhOcY53xvDxwLg+1V
         ojqfzc/r4Kw1bVDzgYyW3QBwqdYLsxt01lQY+IHrfH4tNn8+DFRws6CShimuNXCuweN2
         flKpLfC2XloIlaaVmaQ0Q4qFgbPgLwpCLfpA0=
Message-ID: <4AFC4D31.2000101@gmail.com>
Date: Thu, 12 Nov 2009 19:00:17 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
In-Reply-To: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sincerely, I don't understand why we should involve the kernel to gather
this kind of information when we can use other (user-space) tools, only
to have "all" in a single report maybe? I think it's a bit weak reason
to include this additional behavior in the kernel.

David VomLehn ha scritto:
> Allows annotation of panics to include platform information. It's no big
> deal to collect information, but way helpful when you are collecting
> failure reports from a eventual base of millions of systems deployed in
> other people's homes.
> 

Marco
