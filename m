Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXDTIbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXDTIbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXDTIbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:31:32 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52975 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXDTIbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=owiweNUuCR4QsF1YXx/Ea/6ewOF0pUjegcPS+210qkQH/bfXwEOkmgIVIJfI4mUpLKi9k0xQVPl+8Sb7GqrchUg6hk3UJ58Ns/o4yD7ihaaPs2d/7izr8BHJ17/T6PwkhmyP1N1PKD6FGfLgZtF+tOChXoO+6GSnoTAXypYhy28=
Message-ID: <b637ec0b0704200131g6297d5d5q842edbf160940170@mail.gmail.com>
Date: Fri, 20 Apr 2007 10:31:30 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Brad Campbell" <brad@wasp.net.au>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Cc: "Alex Dubov" <oakad@yahoo.com>, "Sergey Yanovich" <ynvich@gmail.com>,
       linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus-mmc@drzeus.cx>
In-Reply-To: <462877E8.2070005@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <204224.14405.qm@web36703.mail.mud.yahoo.com>
	 <462877E8.2070005@wasp.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

+1

On 4/20/07, Brad Campbell <brad@wasp.net.au> wrote:
> Alex Dubov wrote:
> > Have you looked at the last version (0.8)? It fixed all outstanding issues (as far as I know).
> >
>
> Seconded. I've been running Alex's latest driver since its release. I routinely suspend/resume
> 60-100 times between boots to S3 and disk, I've suspended with cards in the socket and I've tested
> it using SD and MMC .. I've not been able to fault it now. In fact, checking my mail archives, my
> last reported bug was on the 17th of Feb and it has been rock solid since. I just don't think about
> it anymore, it simply works...
>
> Brad
> --
> "Human beings, who are almost unique in having the ability
> to learn from the experience of others, are also remarkable
> for their apparent disinclination to do so." -- Douglas Adams
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
