Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZHKOWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZHKOWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZHKOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:22:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:45320 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZHKOWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TMau3d45+EAyiL/RLFW+lYcf4MuNfHluK2Fj/Zfwa8RnQCwbpH4QpcMax4QPhIRlwy
         B7jt8xzB2UAzrs+P25flfOP/LzHs9rmhil6zz2lPbDyoGRCH1y3kavg1cg9uN2XyHqYA
         Dw5pbtOWJdDxTkXA5o9IzsXxURW5S/rSxsrGY=
MIME-Version: 1.0
In-Reply-To: <1249982534.29180.25.camel@macbook.infradead.org>
References: <3877989d0908101956o303c43c5i5c5f08297afb312@mail.gmail.com>
	 <1249982534.29180.25.camel@macbook.infradead.org>
Date: Tue, 11 Aug 2009 22:22:46 +0800
Message-ID: <3877989d0908110722y7eb0cf5ds74a03512daa4d399@mail.gmail.com>
Subject: Re: [RFC patch] Add boot option intel_iommu_drhd_mask
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 5:22 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Tue, 2009-08-11 at 10:56 +0800, Luming Yu wrote:
>> **The patch is enclosed in text attachment*
>> **Using web client to send the patch* *
>> **below is for review, please apply attached  patch*/
>
> Please use a sane mailer and don't do this. Patches should be inline in
> a usable form.
>
> Surely gmail allows this, even if your employer doesn't provide a
> competently-managed mail service?

I found it is very converient to use web gmail, but didn't find way
to inline in web gmail...
