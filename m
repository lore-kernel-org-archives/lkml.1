Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYCFKzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYCFKzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761327AbYCFKzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:55:12 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:55783 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761108AbYCFKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=lfeRt+kA+lK9Ldffbdr7iqEkQas/vpGANwvy1QdLGorUMT+BG3OEfM61SZMFb/WENAP4S7OelZmdhr9z+w9tq7wq9vnEut4acNiCcurB0XeoHjgN3iIZj68jzBsFfoZ3enPw8yXnQfMPuqgLb/Hdd8scTpRtrkyA0lJxGb+lfLU=
From: Pawel Plociennik <paplociennik@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Thu, 6 Mar 2008 11:54:50 -0500
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu>
In-Reply-To: <20080306102712.GE13391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803061154.51724.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 05:27, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Pawel Plociennik wrote:
> >> Hi Andrew and other *real* hackers,
> >>
> >> I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
> >> It were discusioned a *long time* on a lkml so I hope that it will has been applied.
> >
> > It has been discussed and *rejected* a large number of times.
> >
> > This is completely useless bloat.
> 
> why is it useless? Would it be more acceptable were it made dependent on 
> a .config option?
> 
> 	Ingo
> 
I think that use it as a .config option is a nonsense because it nothing to do
if chroot= parameter has not been used in a booting time.
However as I said before I have *left* this patch and I am not interesting in that now :-(
