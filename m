Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZIPMyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZIPMyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZIPMyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:54:07 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:51955 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935AbZIPMyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nkeGFE7yyO6owxg+yZvGViBxumkRrOeM9SkewpJ3wElsBqfIg4r3eSl6u1VKfmMAW8
         eMKfOliaM6Xks3LzIrrw4ZIPV++f6L6KzH6svYVcMeEv35GASeHS6EZtLIhDxoyCgQh4
         AT8SPz4VxFgVD3TNbqN6kFsZyoY39fm++gOOs=
MIME-Version: 1.0
In-Reply-To: <20090916160651.88b10377.sfr@canb.auug.org.au>
References: <8bd0f97a0909152056h61bfc487g6b8631966c6d72be@mail.gmail.com> 
	<20090915211810.d1b83015.akpm@linux-foundation.org> <8bd0f97a0909152124n186278feja97a7257548b3eb7@mail.gmail.com> 
	<20090916160651.88b10377.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 08:53:46 -0400
Message-ID: <8bd0f97a0909160553r4dae0eb7j345dea2a68fa4310@mail.gmail.com>
Subject: Re: 2.6.32 -mm Blackfin patches
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:06, Stephen Rothwell wrote:
> On Wed, 16 Sep 2009 00:24:37 -0400 Mike Frysinger wrote:
>> not sure how the next process works.  what do i need to do Stephen ?
>
> You send me a request for inclusion with a git tree (and branch)  (or
> quilt series on a web site) and contact address(es) and understand the
> following:

ok, please replace the current Blackfin tree:
    git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git#for-linus
with my Blackfin tree:
    git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git#for-linus

and i'll try to keep it updated
-mike
