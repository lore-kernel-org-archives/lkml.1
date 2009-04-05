Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZDEWmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZDEWmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZDEWmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:42:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:41160 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZDEWmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VKUr73nC1qS2hYgmuTJjfQSSj2S7SDGg98AZtJVhA3vCgJYXBNIDc8OqMF29z9omUv
         1jdCkYDwfAPhkBXDl3CqT48bQCjzrO9RrcXn/ATigWOBDl56cX8FUza3Bd9ZyhL8l7FV
         WI55jXIkv/kyAJjOyAePbP3GKSPdF3LNBTcmo=
MIME-Version: 1.0
In-Reply-To: <20090405062626.GA7760@mit.edu>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	 <20090405011355.GE7553@mit.edu>
	 <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
	 <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
	 <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
	 <20090405062626.GA7760@mit.edu>
Date: Sun, 5 Apr 2009 16:42:13 -0600
Message-ID: <9b1675090904051542o42a0ca11y1ce3b691ed6d8ebb@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

I haven't seen the problem arise for awhile now.  I think it may be
related to editing a file in one of my editors, and not saving it.
The editor might be putting some sort of lock on the file.  I'm
waiting for it to occur again so that I can pin point it.

For now, what about that patch thread sent to LKML called "[tip PATCH
v7 0/9] RFC: futex: requeue pi implementation"???  Do you think that
could have fixed my issue?  I don't have time to try it right now.
And besides, I should try and make it so I can reproduce the problem,
otherwise I might not know for awhile that it's been fixed, after
applying the patch.

I'll let you know more, when I have more data.

Thanks.
