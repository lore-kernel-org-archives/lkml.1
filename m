Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbXJAWLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbXJAWLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXJAWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:11:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:42475 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXJAWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qSi2PJFZj8DlLQSsk4NZ5IEIABs/dat7ejCIRgiyzfOEG89Lp7VIdpW5cbLvgpRMkqb5osTMhKzHPBE7DJ1Bcu90CmikHLelkunzw2GQClTvKFPdhcdv6fTDE1s6OYMyLfiwpHOjdVyyMFaLvY6Psp72Xc1w+Ea39/YyqmyW4ZU=
Message-ID: <47016FEE.6090608@googlemail.com>
Date: Tue, 02 Oct 2007 00:08:46 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-10-01-04-09.tar.gz uploaded
References: <200710011115.l91BFRvg012762@imap1.linux-foundation.org> <47016AFB.7040307@googlemail.com> <Pine.LNX.4.64.0710012352450.22331@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710012352450.22331@twin.jikos.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 1 Oct 2007, Gabriel C wrote:
> 
>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-10-01-04-09.tar.gz
>> I have a question about these snapshots , what is the right way to apply 
>> the patches ? some magic script ? =)
> 
> There is a 'series' file, which tells you the correct order. If you are 
> planning to make any patches on top of mm, you should use quilt for this.

Thx for your quick reply  but I cannot find any series file in this tarball.

Regards,

Gabriel
