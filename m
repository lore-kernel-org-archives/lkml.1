Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbXKPJRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbXKPJRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 04:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbXKPJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 04:17:31 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:42793 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbXKPJRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 04:17:30 -0500
Message-ID: <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
In-Reply-To: <20071116003410.GA16797@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org>
    <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
    <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
    <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
    <20071116003410.GA16797@puku.stupidest.org>
Date: Fri, 16 Nov 2007 10:17:17 +0100 (CET)
Subject: Re: 2.6.24-rc2 XFS nfsd hang
From: "Christian Kujau" <lists@nerdbynature.de>
To: "Chris Wedgwood" <cw@f00f.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Benny Halevy" <bhalevy@panasas.com>, linux-xfs@oss.sgi.com
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, November 16, 2007 01:34, Chris Wedgwood wrote:
> I'm not sure what you're doing here, but a viable work-around for now
> might be to use nfsv2 mounts, something like
>
> mount -o vers=2 ...
> or to keep v3 and disable readdirplus doing something like:
> mount -o vers=3,nordirplus ...

OK, I'll try this. I hope this can be fixed somehow before 2.6.24...

Thank you for your time,
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay

