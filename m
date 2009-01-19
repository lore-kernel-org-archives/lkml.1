Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZASAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZASAv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZASAvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:51:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:63157 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZASAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NsQxUowuoqv0OKPOjm8xben4jQq2787SgZyKn2qn+0gI3+atii1P2j6WXRO9KOWFBu
         b74hIungOAJtdLDLEWN2mFAgMrTU3QvaaSCawvy3Uzey9TxGwsguLPVpLYZiocA+jBaQ
         m6f+hYENBthJKvoBxEnSj+ho+CDx4wSBIzbqg=
MIME-Version: 1.0
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
Date: Sun, 18 Jan 2009 19:51:48 -0500
Message-ID: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 11:39 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Brian, Ingo.
>
> This patchset is 1-12 of Brian's move PDA fields to percpu patchset.
>
>  0001-x86-64-Move-irq-stats-from-PDA-to-per-cpu-and-conso.patch
>  0002-x86-64-Move-TLB-state-from-PDA-to-per-cpu-and-conso.patch
>  0003-x86-64-Convert-irqstacks-to-per-cpu.patch
>  0004-x86-64-Convert-exception-stacks-to-per-cpu.patch
>  0005-x86-64-Move-cpu-number-from-PDA-to-per-cpu-and-cons.patch
>  0006-x86-64-Move-current-task-from-PDA-to-per-cpu-and-co.patch
>  0007-x86-64-Move-kernelstack-from-PDA-to-per-cpu.patch
>  0008-x86-64-Move-oldrsp-from-PDA-to-per-cpu.patch
>  0009-x86-64-Move-irqcount-from-PDA-to-per-cpu.patch
>  0010-x86-64-Move-nodenumber-from-PDA-to-per-cpu.patch
>  0011-x86-64-Move-isidle-from-PDA-to-per-cpu.patch
>  0012-x86-64-Use-absolute-displacements-for-per-cpu-acces.patch

Here are the remaining patches rebased on top of these.

--
Brian Gerst
