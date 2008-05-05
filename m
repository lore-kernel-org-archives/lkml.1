Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYEERth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYEERth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYEERta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:49:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:33366 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYEERta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pP0nyjtdDA6Np3LmEpAWKZZG48L066mdN6vwiNsERDuDOy6mcLkuN9Hwo+FpOGhU2ndPTjbaoe+o93xq+49ch/LDP2Cb1lb+ouPni7WVpAQt02b+VbSTFcD85L5CujaPPVzVbX3Z+zYuuwCFc47luaB80pMHMERXOhfFFiIQzyg=
Message-ID: <86802c440805051042g25e69205tbeb348a63fb1c51e@mail.gmail.com>
Date: Mon, 5 May 2008 10:42:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Cc: "Frans Pop" <elendil@planet.nl>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEFB9204@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805022122.03576.elendil@planet.nl>
	 <200805040910.57088.elendil@planet.nl>
	 <86802c440805041323s1484a8ecx5dbe639d658d015b@mail.gmail.com>
	 <200805051855.05496.elendil@planet.nl>
	 <924EFEDD5F540B4284297C4DC59F3DEEFB9204@orsmsx423.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 10:00 AM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
>
>  >-----Original Message-----
>  >From: Frans Pop [mailto:elendil@planet.nl]
>
> >Sent: Monday, May 05, 2008 9:55 AM
>  >To: Yinghai Lu
>  >Cc: Barnes, Jesse; Pallipadi, Venkatesh;
>  >linux-kernel@vger.kernel.org; Ingo Molnar; Packard, Keith
>  >Subject: Re: [git head] Should X86_PAT really default to yes?
>  >
>
> >On Sunday 04 May 2008, Yinghai Lu wrote:
>  >> can you boot with pat=off and send out /proc/mtrr?
>  >
>  >Hmmm. Is 'pat=off' supposed to do anything?
>  >
>
>  The option for this is actually "nopat".
>
or the PAT has something wrong with WB in MTRR?

YH
