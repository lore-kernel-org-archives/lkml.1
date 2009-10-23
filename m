Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZJWQXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZJWQXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZJWQXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:23:03 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:51136 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZJWQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=r0ZnRsdqCKn27ReSSUt7vgBe/qXYxrq+1ME4h3FcfXxscvoNWEBMSewvznbOJHU7OI
         uDP2CXdYrqVI1xjN1tF64ENfigCgjGiShiEBRC6xRNHHScd3Qf0o4ycrcJ16xkq87VBe
         D1oTdzMILcKRnq2PzGLa9X4PHcWSdLSOsoFEw=
MIME-Version: 1.0
In-Reply-To: <20091023111920.GA5886@elte.hu>
References: <5e93dcec0910200800q2e156fd3v324632efcf136f5e@mail.gmail.com>
	 <4AE02A1B.6020700@redhat.com>
	 <5e93dcec0910220512x50788f59u56e6493778093c7@mail.gmail.com>
	 <5e93dcec0910220836x7f798d45w299129e0c80ed5d1@mail.gmail.com>
	 <20091023111920.GA5886@elte.hu>
Date: Sat, 24 Oct 2009 01:23:06 +0900
Message-ID: <5e93dcec0910230923y39251d46sda97ec3b199be52f@mail.gmail.com>
Subject: Re: [PATCH -tip] sched, cpuacct: fix niced guest time accounting
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       KVM ML <kvm@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ryota OZAKI <ozaki.ryota@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 8:19 PM, Ingo Molnar <mingo@elte.hu> wrote:

> your patch is line-wrapped and does not apply (possibly due to more
> whitespace damage).

Apologies for my bungle. I've resent the patch via git-send-email.

Thanks,
  ozaki-r
