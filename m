Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXE3XRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXE3XRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXE3XRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:17:24 -0400
Received: from gw.goop.org ([64.81.55.164]:33583 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXE3XRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:17:23 -0400
Message-ID: <465E05E7.20409@goop.org>
Date: Wed, 30 May 2007 16:16:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I think we should start there and be prepared to munge the ELF
> magic number if there are problems.  Placing ELF notes is going
> to require a little work but mostly it should be a matter of
> copying the from vmlinux.
>   

Do you have a semi-current ELF bzImage patch on hand I can start playing
with?

    J
