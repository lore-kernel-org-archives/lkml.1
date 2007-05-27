Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXE0ATh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXE0ATh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXE0ATb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:19:31 -0400
Received: from gw.goop.org ([64.81.55.164]:49705 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXE0ATa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:19:30 -0400
Message-ID: <4658CE90.5090008@goop.org>
Date: Sun, 27 May 2007 01:19:28 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <4658C704.2050405@goop.org> <4658CD70.2080702@zytor.com>
In-Reply-To: <4658CD70.2080702@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Pardon me for saying it, but it's hardly a hardship to add support for a
> single additional constant in existing code.  I'm starting to think this
> argument is approaching not just the silly, but downright ridiculous.
>   

Well, if the existing code is a standard libelf/libbfd, it could be tricky.

> Another option is to have the ELF header at a nonzero offset.
>   

Yes, that's exactly what I'm proposing.

    J
