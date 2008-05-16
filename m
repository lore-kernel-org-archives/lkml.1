Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYEPPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYEPPpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYEPPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:45:41 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:50528 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYEPPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:45:40 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/67] aufs document 
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil>
Date: Sat, 17 May 2008 00:45:32 +0900
Message-ID: <18952.1210952732@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Dave,
Thank you for your comments.

About diffstat, actually I send it but the subject was not 0/67.
Please read the thread whose subject is
"[RFC n/2] AUFS: merging/stacking several filesystems"
The last message in the thread which I sent just before the patch series
has diffstat.
Do you want me to re-send it after changing the subject line?

About the number of patches, I have to agree it is large. I chose the
way to make a patch per a new file, and in case of modifying the
existing multiple files I made a single patch. I guess the latter is the
case you wrote "can be folded."

About the description, simple one for the new files because they are
brand new... I wrote a little more in case of modifying the existing
files (see the last patch). Of course a more detail description will be
necessary in future modification.
If you think the functionality is obscure, please read the aufs
documents included in the patch set (the first patches).


Junjiro Okajima


Dave Quigley:
> A couple of comments about this. First off you might want to reconsider
> how you are breaking up the patches. 67 patches seems a bit much to me
> and while the separation between patches is clear it seems that some of
> them can be folded. Second I'm not sure if I haven't gotten it yet or if
> it wasn't sent but I am missing an Email 0/67. Typically this contains a
> description of the patch set, an index of the patches (possibly with
> descriptions), and a diffstat for the entire patch set. The last thing
> is that each patch should have a worth wile description attached to it.
> All of your comments are two lines and that may make sense based on how
> you have it broken up but if you start breaking up the patch set
> differently you will need better descriptions (possibly even now for
> some of the more obscure functionality).
