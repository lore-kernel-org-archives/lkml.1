Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXJHTf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXJHTf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXJHTfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:35:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15271 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXJHTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qL/VyU02ge5NZz2qqBel9j+oGzm/60id/V2eVRTQhfdI4I8eFW97s+q+OEeXFeN0wY7v3GT/OmOBFSUeYiUfBq+qFxCxwCRW9X1Ktv6cAxUJHKKg309Eywxnoem1JTDMDdg21In5gBuJ2XkljwW8ZqQ/SCMZ+QQtm6e4eFoLmhM=
Message-ID: <7b69d1470710081235q3c2fce20sbe41dd3e66def1a0@mail.gmail.com>
Date: Mon, 8 Oct 2007 14:35:11 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: RFC: reviewer's statement of oversight
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Jonathan Corbet" <corbet@lwn.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25555.1191864285@lwn.net>
	 <20071008173706.GA12026@uranus.ravnborg.org>
	 <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Oct 8 2007 19:37, Sam Ravnborg wrote:
> >snip...
> >Acked-by:
> >Tested-by:
>
> * Used by random people to express their (dis)like/experience with the
> patch.
>
> >Reviewed-by:
>
> * I am maintaner or an 'important' person and have had a
>   look at it in depth
---

A couple of months ago there was a thread about Acked-by. At that time
the consensus seemed to be that it was inappropriate for random people
to add Acked-by - that it should only be added by people whose opinion
was expected to a gate for merging. Did the Summit reach a decision
that Acked-by was for anybody and Reviewed-by was for authorities?

I like Randy's point - the assigning of weight to the Reviewer's
opinion is necessarily in the hands of those at the top of the merge
process and there's no need to ask reviewers to decide whether their
opinion matters. In that view, "Acked-by" means "I have no objection
to this patch, but don't claim deep review" and "Reviewed-by" means "I
have no objection to this patch after a thorough review", and either
can be attached by anybody who wants to express an opinion.

scott
-- 
scott preece
