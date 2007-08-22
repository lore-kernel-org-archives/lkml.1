Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbXHVOou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbXHVOou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXHVOon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:44:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:3502 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbXHVOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FkMGyHtiy4YMNeOTZSs1n5v5UzY8TuQssDAAKlqCCyuatwGrwV8zukAaMyNGt27pCOQJ/iYQiw/V2hmdKmXDu95Yyau0X8VRZJv9iG7+G+KZ9N3CXRtdEYrJPXO3o5+ZMDVyzOq3s/icjK3ac8Jm8j0s11g0KPUzXBam4KMUSeE=
Message-ID: <f9d2a5e10708220744h7b0c86dbs34c3aee24ec610b2@mail.gmail.com>
Date: Wed, 22 Aug 2007 07:44:39 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: What must I do to get HPET
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73y7g3yfzv.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20070822T045428-445@post.gmane.org>
	 <p73y7g3yfzv.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug 2007 13:18:28 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Russ Dill <Russ.Dill@gmail.com> writes:
>
> > I have an Acer Ferrari 5000 laptop, it has an AMD64 TL-60 processor, and an
> > RS480 host bridge. I'm running 2.6.22, I get no HPET.
>
> Actually it needs the 'HPET' table.
>
> > Do I need to get Acer to update the BIOS to include a PNP0103 entry? Is there
> > some way I can force this?
>
> Yes they'll need to update the BIOS. They likely have one available
> unless it's an old box because AFAIK getting a Vista logo requires HPET.
>

It came pre-installed with vista ultimate. I can't seem to locate a
vista logo on the box or in the manual. However, the webpage does
clearly show a windows vista logo:

http://global.acer.com/products/notebook/fr5000.htm

I have the latest BIOS, what gives?
