Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbZJPENf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbZJPENf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZJPENf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:13:35 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:50478 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZJPENe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:13:34 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 00:13:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBbcU1MRzMOIumkJGuulQYflZfS8+87Noyi31Sb9toLWfST40t9bsGZR4G7S733QI4
         dbJwvHt8gMzlobC0xD+r77THoVMxmbMc+EuLUKxP71DpbAjaUvqmTC5lg9yfFtF3YnSU
         1dzqd1Vi1MA6UxXWnKY/pfvph0+g8+gp/Kek8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0910151756550.4017@localhost.localdomain>
References: <alpine.LFD.2.01.0910151756550.4017@localhost.localdomain>
Date: Fri, 16 Oct 2009 12:07:57 +0800
Message-ID: <3f8c8fb90910152107v23e60c95w8bc52d3aa999a461@mail.gmail.com>
Subject: Re: Linux 2.6.32-rc5
From: Steven Yong <woongiap@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 9:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> [ Git tip of the day: if somebody wants to really see the size of patches,
>  do something like
>
>        git log --no-merges --oneline --numstat -M v2.6.32-rc4..v2.6.32-rc5
>
>  and you'll get a reasonable view of the patches with number of lines
>  added and removed. You'll see how the commits that add the new drivers
>  really stand out, while the other commits really are largely "just a few
>  lines" each. ]
>
Or git log --no-merges --numstat --pretty=oneline --abbrev-commit -M
v2.6.32-rc4..v2.6.32-rc5 if you are not using latest git.

steven
