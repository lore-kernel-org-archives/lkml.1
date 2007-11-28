Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXK1LpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXK1LpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbXK1LpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:45:01 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:29477 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653AbXK1LpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VKPWcgtDKtEVZSekWtdvQF5sXzHzNg2ZCAq1kYvj77ATBHpKo2AgHc4/fLCYDxvcr3ZAilQ2FmgmDOoQnAcReZhXuU58fHKEsK0EIQ5j0x/R9UA5CAuRYrxtFdK67AN2rl3kvHlaIAUuBY6fqIuhQm41wYoKWdG7LtildlVEs2Y=
Message-ID: <e85b9d30711280344p816ef2araef7532c00821112@mail.gmail.com>
Date: Wed, 28 Nov 2007 12:44:58 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: CFS scheduler, -v24, for v2.6.24-rc3-git3 / current git state
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071128112438.GA321@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30711280217j104f3117oac4a0fe5bedb5cf1@mail.gmail.com>
	 <20071128112438.GA321@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> cool. Which scheduler are you comparing this to - v2.6.23-ish? Or
> CFS-v22?
>

compared to v22 & that of 2.6.23
cfs of v2.6.23 was quite "nice" with some great stuttering - dunno why
the best besides current was v19.1 or v19.2 (sound stuttering was a
little stronger I think but desktop "feeling" was definitely better
than v22 and that of 2.6.23)  if I recall right 2.6.21 + cfs backport
/ cfs patch


>
> which patches does "ck-patchset" carry at the moment? One would be
> swap-prefetch i guess, right?
>
the swap prefetch patch at least I think, I need to ask waninkoko,
he's maintaining the zen-sources git-repository

> thanks :)

Your welcome, linux needs improvement wherever it can get - until it's
the "best" OS out there  :)

Mat
