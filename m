Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZHRKex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZHRKex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZHRKex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:34:53 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45913 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZHRKew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p4vf/w51kjBl4ilG7DB2JKJWPmn8vmIehQni9Dje8O7F1fGT1ePslYStVw+sgwnx44
         Ntx+fZENhI0TpRberezC6SwFutwkbf3FfIF9RHEYcOOycQG4cRbR580aCNYZuEVo3Mhc
         GNtASrFRIcRRtGyRvtucgkSQ/lllZWlKmNSEY=
MIME-Version: 1.0
In-Reply-To: <20090818102136.GN29655@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de>
	 <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
	 <20090814204305.GA31727@pengutronix.de>
	 <20090815103532.GA5596@sig21.net> <4A8A7D38.5020201@gmail.com>
	 <20090818102136.GN29655@pengutronix.de>
Date: Tue, 18 Aug 2009 12:34:52 +0200
Message-ID: <81b0412b0908180334u51fd957dh36f2a4946dffbb0b@mail.gmail.com>
Subject: Re: New fast(?)-boot results on ARM
From: Alex Riesen <raa.lkml@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Johannes Stezenbach <js@sig21.net>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:21, Robert Schwebel<r.schwebel@pengutronix.de> wrote:
> - In general we want to have our systems close to what the mainline
>  does; Automation & Embedded is only a small market, and anything
>  which is *not* specific to these markets but mainline is good.

BTW, what is your mainline (or it looks like you mean "upstream")?
