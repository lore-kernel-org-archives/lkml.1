Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZHFWRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZHFWRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZHFWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:17:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57093 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZHFWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ONXt+JwitSCzbBG3Z953JX3mVb3kiCGwpUbUyu5FOhBjCFAycDBkt8ke3N9Qbx+LH5
         0pmTqugbBxZ3CawSC4kn8WLA9PSzPp9B+nnL86noUG78Ol93HgSn3AH9YIktNE67xyA2
         xEM3XT1PEkBFSjwVtYy17iPyQWn2jCG7ciPvM=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Fri, 7 Aug 2009 00:17:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.29-ARCH; KDE/4.3.0; x86_64; ; )
Cc: Michal Soltys <soltys@ziu.info>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200908061553.23525.alberto6674@gmail.com> <20090806143012.126b1595@jbarnes-g45>
In-Reply-To: <20090806143012.126b1595@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908070017.08070.alberto6674@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009 23:30:12 Jesse Barnes wrote:
> > Hi,
> >
> > No updates here? I was wondering if it would be more useful to open a
> > bug report so that it doesn't get lost. It is a rather nasty bug that
> > keeps me using .29 kernel, and since it seems to be clear where the
> > problem is it seems a pity to let it go...
>
> Yeah, sorry was on vacation.  A bug report would be great, can you
> file one at bugs.freedesktop.org against drm/intel?  I think I know
> where the issue might be, but I'll have to come up with some more test
> patches for you.

Fine, I'd be glad to test any patch (though I will be away the next week on 
vacation too).

Here is the bug report:
http://bugs.freedesktop.org/show_bug.cgi?id=23183

Regards,
Alberto.
