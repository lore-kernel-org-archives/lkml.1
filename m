Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbYEBSZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbYEBSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763022AbYEBSZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:25:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:53955 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762533AbYEBSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i6J1KLexatsUnXE5ghn7XuFj+kjmnRICgkREEx3iRbbWfCWBy1uJm3Op4ah0Uo8nBjwPP6etqa0DAotFZP8z+RfrP5gcQy802GX8Hzp9gBSydKLH7Pp8fhGDwtHa9NrtsunnL33Ia1dzf46Z4tmrbwNSkpqFbEOt3/QqcubhRR8=
Message-ID: <82e4877d0805021125y1e11deb4qaa57ac493cf41aba@mail.gmail.com>
Date: Fri, 2 May 2008 14:25:47 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080502180151.GD5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
	 <200805021229.47038.dhazelton@enter.net>
	 <82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com>
	 <20080502180151.GD5838@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 2:01 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Fri, May 02, 2008 at 01:30:23PM -0400, Parag Warudkar wrote:
>  > I wasn't arguing that it is what should be happening - I was just
>  > pointing out that there are worse things than that routinely happen in
>  > distro bugzillas!
>
>  And the point is?
>

Point being that no one can force anyone to do anything in the setting
in which kernel developers work.
Distros have been doing this since ever and people have no choice but
to move on.
(Everybody works out of their own (or employer's) interest and
judgement - so telling some one to act otherwise will not be a whole
lot productive.)

>
>  You completely miss the point.

I am not - my point is that you can't do  much about it that will go
long way in resolving the issue.

>  And in any case, being more friendly to a bug submitter.

Well again -  you can't force people to do something like that. In
your example it would amount to the maintainer going against his/her
own judgement - however wrong it is to you and me, to the person who
can actually fix it - it's not a possibility. So you have to just
accept it and reassign it to some one else who is interested/capable -
for that I suggested tracking such bugs under a new STATUS.

Parag
