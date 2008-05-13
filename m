Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYEMPHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYEMPHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYEMPHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:07:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:50267 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYEMPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SVzrJPd/TlNeG5I1m3x6+aDaGj8U/eRUdeFjhjyHv9FNt4JO0bIBPMogTv/uJI4wW+GhiQeBtBh6EEG0mMnfjUH+kAfj5alFrWi9nmI3CQfU7sk1Qjkw85yflLa3sdeugGCsL4prUINCoJRlQ6OONJMcWo6ih8IMuge8EQ35FpM=
Message-ID: <386072610805130807l3e3943e1w24c38b640ab331a6@mail.gmail.com>
Date: Tue, 13 May 2008 23:07:16 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Cai, Cliff" <Cliff.Cai@analog.com>, "Bryan Wu" <cooloney@kernel.org>,
       liam.girdwood@wolfsonmicro.com, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
In-Reply-To: <20080513140132.GG21292@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210589112-12208-1-git-send-email-cooloney@kernel.org>
	 <20080512115416.GB23216@sirena.org.uk>
	 <0F1B54C89D5F954D8535DB252AF412FA01F2EF2C@chinexm1.ad.analog.com>
	 <20080513140132.GG21292@sirena.org.uk>
X-Google-Sender-Auth: 100287a4112763c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:01 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 13, 2008 at 11:00:58AM +0800, Cai, Cliff wrote:
>
>  >  ok,we will implement these two functions later.
>
>  So they can be removed for now?
>
>  What's the current status of merging the Blackfin ASoC support?

We plan to cleanup the Blackfin ASoC code, after that we will send out
the code for merging.

> We've had patches in the ASoC git tree for some time (along with the AD1980
>  driver) - it'd be good to get everything merged into ALSA.
>

Do you mean there is another version AD1980 in ASoC git tree?

Thanks
-Bryan
