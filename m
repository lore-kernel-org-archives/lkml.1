Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYFKPff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYFKPff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYFKPf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:35:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:39027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYFKPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:x-face:cc
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=RcSTuI1PKRv6VhQ/Uiqw8w5dOk1QGibwVrhek5P4IzXgpa5GmMGH2mUKO9/vIl0Koi
         LQaWM72SSrZ0TV3nBRupDLhMZku199SvSqv2KHirIlh66F+7k9rDQeK7zuD0kmj15CYE
         4odpmEGuXQLkM1B5fPoYwdOZmS3dHkDZ1YgKQ=
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Date: Wed, 11 Jun 2008 17:35:19 +0200
User-Agent: KMail/1.9.9
References: <200806102152.23286.solstice.dhiver@gmail.com> <200806111615.11997.solstice.dhiver@gmail.com> <alpine.LNX.1.10.0806111636460.20733@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0806111636460.20733@fbirervta.pbzchgretzou.qr>
X-Face: i>^wU`a5]X{;$5ES3H1eQT1&yA%vQ<5`86sMzPN6/-61({uZALpE4Oe-6<=?utf-8?q?=60DNbFz=3D/UJ7r=0A=09v=23KV2Y=5Ew=23Sg?="1kfpw3e<f_"VS?tx&ZXn*-Npn4(l\73LF*1?wwveK$~1ys@=?utf-8?q?CTT=276=24fWx=24W=0A=09?=)0!v7wC(KkkO[+j.Etu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111735.19935.solstice.dhiver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> says who? http://rt.et.redhat.com/download/older/patch-2.6.25.4-rt5.bz2
oops.

so i have tested 2.6.25.4-rt {3,4,5}
and all the 3 have the same issue (no cpu MHz in /proc/cpuinfo here)

my hardware is a dell inspiron 531 (with bios 1.0.9) with Athlon 64 x2 4400+ 
as you already know, a motherboard with MCP61 chipset. 

