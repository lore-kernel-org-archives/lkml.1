Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYE3ToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYE3ToS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYE3ToC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:44:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:20469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYE3ToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mqExEnW14exjqTDzJ2BFF+iWqWFt2AUaNNxNLw8RgRiSs/yAGzyWzJcubmtMoeBNm+WgbjrsoYw0bnjRX+RklsYKxZeC6D+hlI4PltN7JNzPV16fFETbyvBEkl25V7mJ+/uhb1Uf298jmRCFir22LPCMi6r/obZaUrB8v56u0WE=
Message-ID: <cfd18e0f0805301243h7d862963o8320a2c1f48942ce@mail.gmail.com>
Date: Fri, 30 May 2008 21:43:59 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <E1K27bZ-0002Gk-3b@pomaz-ex.szeredi.hu>
	 <cfd18e0f0805301124o5f217dden10726b268d05d81a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

You omitted to answer my question, the last sentence below:

On Fri, May 30, 2008 at 8:24 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Miklos,
>
> I already fixed most of the isues with utimensat() in my previous
> version of the patch several days back, and that patch (probably
> still) applies against current mainline.
[...]
> This is a bug.  It is one of *several* bugs in the original
> implementation of the utimensat()/futimens() interface.  All of them
> should be fixed.  I have by now provided fixes for most of them.  (Not
> point 2 above, but with a little help that should be quickly fixed as
> well.)  At this point, I think you need to explain why you think those
> fixes shouldn't be applied.

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
