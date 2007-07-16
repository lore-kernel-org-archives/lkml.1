Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXGPVfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXGPVfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763825AbXGPVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:34:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763101AbXGPVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0fwwAx92lDq9q16tYqEKr9Z5TaZSXFcLhXikOGiXypGHjKlWi/f1rD4eNx5ZxLDw+YE+Tw1hLdIITfSAAo6APyyoUWC48RFwRAw4ckDkA2A+xhJZ4f1mWcZ3w4/AWPuCrXxOqjtf7a0myfwlb6WJcy2crx6xRmbTnNPExO+beQ=
Message-ID: <6bffcb0e0707161434n8f1873cpd8c795292097bf1f@mail.gmail.com>
Date: Mon, 16 Jul 2007 23:34:47 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: Linux Kernel Development
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4d8e3fd30707161404u49108231kae05aa80180a8857@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4d8e3fd30707161404u49108231kae05aa80180a8857@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

On 16/07/07, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> Hi all,
> I'm the author of the document "Introduction to Linux Kernel
> Development Process" hosted at
> http://linux.tar.bz/articles/2.6-development_process.
> Part of the document has been included in Documentation/HOWTO
>
> I was reading  both the documents while I started, again, to think
> about how to improve the quality of the vanilla kernels.
>
> Here are a few line of the document I wrote:
>
> ---8<------8<------8<------8<------8<------8<------8<------8<------8<---
>  --- 2.6.x kernels ---
>
> 2.6.x kernels are maintained by Linus Torvalds,
> it's development is as follow:
> - As soon a new kernel is released a two weeks windows is open, during
>   this period of time maintainers can submit big diffs to Linus, usually
>   the patched sited in -mm kernels for a few weeks.
>   Preferred way to submit big changes is using GIT
>   (more information about GIT at http://git.or.cz/ and
>   http://www.kernel.org/pub/software/scm/git/docs/tutorial.html).
> - After two weeks a -rc1 kernel is released and now is possible to
>   push only patches that do not include new functionalities that could
>   affect the stability of the whole kernel. Please note that a whole
>   new driver (or filesystem) might be accepted
>   after -rc1 because there is no risk of causing regressions with
>   such a change
> - A new -rc is released whenever Linus deems the current git
>  (the kernel's source management) tree to be in a reasonably sane state
>   adequate for testing. The goal is to release a new -rc kernel every week.
> - Process continues until the kernel is considered "ready", the
>   process should last around 6 weeks ( 6 kernels per year should be
>   released) an usually includes 4/5 rc releases.
> ---8<------8<------8<------8<------8<------8<------8<------8<------8<---
>
> The sentence "Process continues until the kernel is considered "ready"
> " should probably be changed in order to reflect the usage of the
> "regression list" that Adrian and then Michal were used to maintain.
>
> Is there a "stable" place were users can read/comment/modify the list?

This address should be widely known ;)
http://kernelnewbies.org/known_regressions

> Wasn't Google interested in employee a person to take care of
> regression/bug report? (Yes, if there is an open position I would be
> interested in applying ;-).
>
> Thanks!
>
> Regards,
> --
> Paolo

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
