Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYBTJLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYBTJLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYBTJLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:11:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:50992 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYBTJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:11:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G5vT0bE3W3KZsCNRBYgLeCGI+M71e2+8C/znyoVOO68MkSVawGOo9fzacecFv2Knpm5C1sM4zK1JQNTds8u/uxbKcfXElScVDP+kSvRw91vK+k8PSOVzxWOyI7vosPJKE4pSBK4RiLAyOr5+7Ys4Nu5piSEVm6plI2mwHMYyG/E=
Message-ID: <4d8e3fd30802200111m570e8052pf960298c2d9dbe19@mail.gmail.com>
Date: Wed, 20 Feb 2008 10:11:02 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: Coding style fixes to arch/x86/mach-generic/probe.c
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080220085824.GA29899@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219235717.0a4c69e2@paolo-desktop>
	 <20080220085824.GA29899@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 9:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > -     for (i = 0; apic_probe[i]; ++i) {
> > -             if (apic_probe[i]->mps_oem_check(mpc,oem,productid)) {
> > +     for (i = 0; apic_probe[i]; ++i) {
> > +             if (apic_probe[i]->mps_oem_check(mpc, i oem, productid)) {
>
> you typoed that one. Please build-test files you change.

Yup, sorry about that!
Won't happen in the future.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
