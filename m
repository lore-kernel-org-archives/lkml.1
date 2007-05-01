Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXEAREf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXEAREf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXEAREf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:04:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:23873 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbXEAREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mC/9tPrCFBKNRr1HbW+inct9mPB3F/Jcf5Vt0ReXXdiNdiYmDJlYe5CWxxbzdmnrn8cLJWnhSKbdGVM3784ea0BxcjdQLuDG6I+VGOGI9P3HLe316S0j8nITI8/1OJX8h6opJhWNidOnAvrLVceMX5KXgGcoXn/JovGzR4+J0WQ=
Message-ID: <6ec7a4340705011004s742cd7b9sea9ee73e0b8230ef@mail.gmail.com>
Date: Wed, 2 May 2007 01:04:32 +0800
From: "Xu CanHao" <xucanhao@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Xu CanHao" <xucanhao@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
In-Reply-To: <20070501161707.GD26093@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6ec7a4340705010617h4314045cj7f0aee42eb22292b@mail.gmail.com>
	 <20070501161707.GD26093@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/2, Theodore Tso <tytso@mit.edu>:
> On Tue, May 01, 2007 at 09:17:14PM +0800, Xu CanHao wrote:
> > Reiser4 may lack some core function, but ZFS on Solaris is as
> > functional as ext3 on Linux(or even more). So compare Reiser4 with
> > ZFS may be inappropriate.
>
> Functional, but it's a new filesystem with not as much time-tested
> experience in the field.  Many Solaris system administrators are
> electing to wait rather than immediately press it into service for
> critical servers, electing to use Solaris's UFS instead.  I've heard a
> few problems with ZFS recovering from data corruption, but not enough
> to know whether it is a general trend (not that I track that kind of
> stuff).  As a rule, enterprise system administrators that run PO
> servers for thousands of users as a time are extremely conservative,
> and for good reason.
>
> Of course, there's a big difference between those folks and people
> using ZFS for their own personal development.
>
>                                                 - Ted
>
On May 1, 1:50 am, Theodore Tso <t...@mit.edu> wrote:
>
> In general, yes, ext4 development has been a little slow; part of the
> problem is that we have a lot of people, but a number of folks are new
> and their patches need review before they are ready for upstream
> acceptance, and a number of other folks who should be doing the review
> have been overloaded with multiple other projects and have been
> time-sharing.

It is predictable that ext4 needs a loooong time to be enterprise-ready ;)
