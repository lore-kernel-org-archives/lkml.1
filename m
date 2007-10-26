Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbXJZWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbXJZWQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXJZWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:16:32 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:55957 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753584AbXJZWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:16:31 -0400
Message-ID: <47226755.8090106@crispincowan.com>
Date: Fri, 26 Oct 2007 15:16:53 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
References: <20071026064024.243943043@suse.de>	<20071026073721.618b4778@laptopd505.fenrus.org>	<200710262244.57147.agruen@suse.de> <20071026141358.38342c0f@laptopd505.fenrus.org>
In-Reply-To: <20071026141358.38342c0f@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> My main concern for now is a description of what it tries to protect
> against/in what cases you would expect to use it. THe reason for asking
> this explicitly is simple: Until now the LSM discussions always ended
> up in a nasty mixed up mess around disagreeing on the theoretical model
> of what to protect against and the actual implementation of the threat
> protection. THe only way I can think of to get out of this mess is to
> have the submitter of the security model give a description of what his
> protection model is (and unless it's silly, not argue about that), and
> then only focus on how the code manages to achieve this model, to make
> sure there's no big gaps in it, within its own goals/reference.
>   
I really, really like this proposal. It is essentially what I have
always wanted.

> On the first part (discussion of the model) I doubt we can get people
> to agree, that's pretty much phylosophical... on the second part (how
> well the code/design lives up to its own goals) the analysis can be
> objective and technical.
>   
I will try to do that as soon as possible. While I will strive to be
both clear and precise, achieving both is challenging. So, if someone
discovers a mis-match between the description and the code, would a
patch to the description be an acceptable resolution, if it did not
render the model silly?

Crispin

-- 
Crispin Cowan, Ph.D.               http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

