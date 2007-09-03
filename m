Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXICATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXICATT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 20:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXICATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 20:19:04 -0400
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:43779 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXICATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 20:19:02 -0400
From: Junio C Hamano <junkio@pobox.com>
To: Sean <seanlkml@sympatico.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Kastrup <dak@gnu.org>,
       git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>
	<46DA5F33.2020005@zytor.com> <85odgltrtj.fsf@lola.goethe.zz>
	<46DA88EF.7080103@zytor.com>
	<20070902133803.1b46f599.seanlkml@sympatico.ca>
	<7v4picpvgq.fsf@gitster.siamese.dyndns.org>
	<20070902191644.29d46cd2.seanlkml@sympatico.ca>
Date: Sun, 02 Sep 2007 17:19:00 -0700
In-Reply-To: <20070902191644.29d46cd2.seanlkml@sympatico.ca>
	(seanlkml@sympatico.ca's message of "Sun, 2 Sep 2007 19:16:44 -0400")
Message-ID: <7vejhgob2j.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sean <seanlkml@sympatico.ca> writes:

> On Sun, 02 Sep 2007 15:13:09 -0700
> Junio C Hamano <gitster@pobox.com> wrote:
> ...
>> For majority of general public, I thought the spec file _I_
>> ship, along with RPM files _I_ build, are contrib status
>> already.  Don't distro people do their own RPM packages, instead
>> of using what I placed on k.org?
>
> Didn't know you used RPM yourself, so I guess this is just
> a case of something slipping through rather than the spec file
> needing a maintainer.

Well, I do not _use_ it, but the RPM I have on k.org and mention
as part of the announcement are built by me by typing "make
rpm".  What I meant to say was that these RPM files may not be
"official" at all from the point of view of distro users, and I
suspect that distro "package maintainers" for git would not be
doing just a plain vanilla "make rpm" using the spec file that
comes as part of git.git repository.

