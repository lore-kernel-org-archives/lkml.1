Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYFKOP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYFKOP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYFKOPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:15:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:25205 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYFKOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face:cc
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HzryhnJOXoERmCSGV9oe0a3TpR7WlZ379CzanezbLPXch0krvguXdvGVED49bB9Q8k
         Suno2MZS9dch9FTBRE/cZ8jtuhpYQA37xhCJ5VVwlsZQlVSyoLVEh1AxvrOfZxe9Xm8o
         /KryjUWFS72bKvxlJ/2i4XgIQxIMNQsHqaLGA=
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Date: Wed, 11 Jun 2008 16:15:11 +0200
User-Agent: KMail/1.9.9
References: <200806102152.23286.solstice.dhiver@gmail.com> <alpine.LNX.1.10.0806111440080.20733@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0806111440080.20733@fbirervta.pbzchgretzou.qr>
X-Face: i>^wU`a5]X{;$5ES3H1eQT1&yA%vQ<5`86sMzPN6/-61({uZALpE4Oe-6<=?utf-8?q?=60DNbFz=3D/UJ7r=0A=09v=23KV2Y=5Ew=23Sg?="1kfpw3e<f_"VS?tx&ZXn*-Npn4(l\73LF*1?wwveK$~1ys@=?utf-8?q?CTT=276=24fWx=24W=0A=09?=)0!v7wC(KkkO[+j.Etu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111615.11997.solstice.dhiver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have 2.6.25.6-rt6 here, so:

> cpu MHz         : 1666.737
>
> it's there.

if i remember well it was there too with 2.6.25.4-rt5. i mean with _rt5_ 
patchset. 
but i am not sure and can't test it now because rt5 patch is not available 
anymore...

