Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbZICW4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbZICW4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbZICW4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:56:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56685 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbZICW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=om4ogMhIBBKiub9aPQ9dQ86TLsw8H7Hcbw3hwf3VPj3VzwCwxx8zN0s10q/oXhb4Ol
         hWhFfmZ87oqoxTkyauecQ2VjOHmvNneO3AMw9MFRwq29+x9T1INapRLJ6RLZRhVq5BUr
         l3Y1N25hTg6OI0po6vQKikPvMqo1B5exyz56c=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0909020308510.27310@eddie.linux-mips.org>
References: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com>
	 <alpine.LFD.2.00.0909020308510.27310@eddie.linux-mips.org>
Date: Fri, 4 Sep 2009 04:56:01 +0600
Message-ID: <b9df5fa10909031556i3d87ff72v3ce4ed8bcd4e5dd@mail.gmail.com>
Subject: Re: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be 
	const?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/09, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>
>  All the three have meaningful semantics on writes at least on some
>  versions of the APIC (they either have writable fields or trigger side
>  effects on writes).  It looks like your documentation is wrong (not
>  unheard of with Intel).

Thanks, Maciej. If my documentation is wrong, then which documentation
should I follow? Isn't there any well defined document?
>
>
>   Maciej
>
