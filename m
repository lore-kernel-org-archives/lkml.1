Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZHCNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZHCNxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZHCNxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:53:44 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59201 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbZHCNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uM4bFcwZzotRZB2BALsr4T6oExHTFXqtjxsh6j7G0xA0+u0T0Kqkf+2XeJYuUArruK
         ol4dqeBDgOGNki8ieFmF0FBfvlv74wUHHA63LE9Brzcnw1+5KKH6N/N1vvdXKLzgzwNk
         inTG/wn96uUQpPnilwiTagQRjhMnXGS3KJAFo=
Message-ID: <4A76EBD3.6010006@gmail.com>
Date: Mon, 03 Aug 2009 21:53:23 +0800
From: Eric Miao <eric.y.miao@gmail.com>
Reply-To: eric.y.miao@gmail.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Eric Miao <eric.y.miao@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the pxa tree with Linus' tree
References: <20090803110314.1c2c3cca.sfr@canb.auug.org.au>
In-Reply-To: <20090803110314.1c2c3cca.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Eric,
> 
> Today's linux-next merge of the pxa tree got a conflict in MAINTAINERS
> between commit 8b58be884a9fd650abb7f7adf3f885fb9cecd79d ("MAINTAINERS:
> coalesce name and email address lines") from Linus' tree and commit
> 4ad9febe53347962225169c5bde2ec030e46ab1d ("Palm Tungsten|C initial
> support") from the pxa tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Stephen,

Thanks for the fix.
