Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYJUNDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYJUNDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYJUNDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:03:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:57480 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbYJUNDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=mEqkgguwf6D5/r+fgXeFEQEHKdJKG8T2Z+P1b7+c3YFUD3FF4RrucWCSOfa06m5yqv
         xG6gmlwhQ1vpEiL8W5DQgqFCzOo8TkhzrBap1X7o2dgeor9OXqL1pEargyMVQfwIlhwk
         8KDFsy7waFAyT9E0Yq//Hla+vkWCX646zF+5c=
Date: Tue, 21 Oct 2008 09:02:01 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21
Message-ID: <20081021130201.GB31686@yoda.jdub.homelinux.org>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au> <20081021120735.GA10567@yoda.jdub.homelinux.org> <20081021231421.a9cdfcb4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021231421.a9cdfcb4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 11:14:21PM +1100, Stephen Rothwell wrote:
>Hi Josh,
>
>On Tue, 21 Oct 2008 08:07:35 -0400 Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
>>
>> On Tue, Oct 21, 2008 at 07:51:09PM +1100, Stephen Rothwell wrote:
>> >I have also applied the following patches for known problems:
>> >
>> >	sparc: qlogicpti fallout from sbus removal
>> >	ibm_newemac: Fix new MAL feature handling
>> 
>> Did you?  I put that in my next branch, which Ben pulled into his powerpc
>> tree, so it shouldn't have needed applying separately.
>
>It got into Ben's tree way after I started building linux-next for
>today.  Tomorrow I will indeed not need it any more, thanks.

Ah.  I sort of guessed that after I sent out my first mail.  Silly me
for emailing before coffee again.

josh
