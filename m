Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbXFLUZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbXFLUZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXFLUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:25:05 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:38390 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbXFLUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Av2gxWOfvbomfych6fZLmTmjE/6kdTnc5M4bj4yb1McQPzVYcRe7KQfg2itLt1a7HdFbOD4EeOMWFdbhLgzw29iBjU0AOHqDU+Cx6wy4fZ0z9loI+ncdg/FXCvJ/XMdMr1Pa0x25XoOZhVrNLitN1+bXRtwNVyIBjZCU5244UG4=
Message-ID: <a800cda90706121325p18c85b00r7bc4b15b95517371@mail.gmail.com>
Date: Tue, 12 Jun 2007 16:25:01 -0400
From: "R.F. Burns" <burnsrf@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: PC speaker
In-Reply-To: <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a800cda90706120545w2c6d0bb0vb77bd4d961415c5c@mail.gmail.com>
	 <75b66ecd0706120744g7cdb3392l6537b5c68c2d6b21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Lee Revell <rlrevell@joe-job.com> wrote:
> On 6/12/07, R.F. Burns <burnsrf@gmail.com> wrote:
> > Is it possible to write a kernel module which, when loaded, will blow the PC
> > speaker?
>
> LOL.  May I ask what your use case is?

I am helping a small school system with a number of Linux
workstations.  Previously, the students (middle and high schools)
abused the sound cards in the systems.  This was remedied by changing
the permissions on sound devices so that non-root users would be
denied access (something easily done remotely, and on an automated
basis.)

At that point, the students started finding creative ways to abuse the
PC speaker, which became rather distracting.  We unloaded and disabled
the PC speaker kernel module, which remedied the situation for a
while.

However, over the past several weeks, the students have found more
creative ways to abuse the PC speaker (outside of the OS.)  The Powers
that Be are asking that the PC speakers be disabled completely.  With
the small number of techs we have, it would be very impractical to go
around to all systems and remove the PC speaker from each and every
computer case.

So, the idea was raised about seeing if there was a way to blow the PC
speaker by loading a kernel module.  If so, a mass-deployment of a
kernel module overnight would take care of the PC speaker problem once
and for all.
