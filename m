Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0ALRjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0ALRjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896Ab0ALRjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:39:10 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64601 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:39:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dgCTATcUaQAMksUf/pRR4U27E9sXhyNQn3ROO+5qbzbUapzUYNhcvS0EGYe2ohBYEu
         cGXeUDkcvouBXMA2UqyfGs9r2aSud2ZF+SuA8AvXgl4z9Zri/Diu4eUKWKL9QoDKcn1o
         uI5vjuA3Fz4mkbewk3tKzrPNCePFBqirOpEh0=
Message-ID: <4B4CB3B5.3060900@googlemail.com>
Date: Tue, 12 Jan 2010 18:39:01 +0100
From: Johannes Engel <jcnengel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc3-git3: Reported regressions 2.6.31 -> 2.6.32
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.01.2010 23:45, Rafael J. Wysocki wrote:
> This message contains a list of some regressions introduced between 2.6.31 and
> 2.6.32, for which there are no fixes in the mainline I know of.  If any of them
> have been fixed already, please let me know.
>
> If you know of any other unresolved regressions introduced between 2.6.31
> and 2.6.32, please let me know either and I'll add them to the list.
>   
How about #15004?

Cheers, Johannes
