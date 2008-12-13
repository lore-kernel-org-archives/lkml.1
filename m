Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYLMBQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYLMBQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYLMBQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:16:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:46545 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYLMBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=hvmmCO5AW13LTgZ7FuJELiPT1gKP2i7xAUkhMDg5d1t/BBaFmakjdx9jwP8Iv/gqGw
         QLglrHEeNSmCaF1AwYj9BeGMvoTADyJmYoZJ+PGNa5PvkspTcmhaiDHzvJiKvS+TgQoF
         I05nBSX88IPzbRJLRyZN4Y0njN+yjO8Y2tKFo=
Message-ID: <bd6139dc0812121716w73ea1145w7f870e887e00adc0@mail.gmail.com>
Date: Sat, 13 Dec 2008 02:16:34 +0100
From: "Sverre Rabbelier" <alturin@gmail.com>
Reply-To: sverre@rabbelier.nl
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] Simplified GIT usage guide
Cc: "Jakub Narebski" <jnareb@gmail.com>, torvalds@osdl.org,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <32073.1229130284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
	 <m33agtgp2v.fsf@localhost.localdomain> <32073.1229130284@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 02:04, David Howells <dhowells@redhat.com> wrote:
>  (3) You put some non-basic stuff in the basic section (branching - this isn't
>     ordinarily useful, IMHO), but you miss other stuff out ('git rm' for
>     example).

Erm, branching is not ordinarily useful? I think you're Doing It Wrong
(TM) then, since branching is a Big Thing (also TM) in DVC, not using
branches would be a bit like only using the first 4 gears in a car;
sure, it's possible, but you're missing all that extra power!

>  (4) It needs to be installed with GIT in a form that can easily be cut and
>     pasted from (maybe this is the case).

I'll agree with you that the git-scm site is in fact, a site, and as
such cannot easily be accessed.

>        github

First hit on google:http://github.com/

>        repoorcz

http://repo.or.cz

I'm sure both are supposed to be hyperlinks, and some text there as well.

-- 
Cheers,

Sverre Rabbelier
