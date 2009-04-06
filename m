Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZDFUep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZDFUep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZDFUef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:34:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:45537 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZDFUee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CiDgAk1vJL+EzDNm38uQspgkgQKQ+5fjv64CfDpgBJy/+LzjoHkTOhX4tbrJ0N56Hq
         AB5pd+d7e8paTOU+7VgV1XTCluZlFr2TylriAxxjtuEpsPaiZEr5KA5C4VBBxFqupomo
         upwlNs1N+CoG0sN/5Jd+ndvZG07NKtnIjPyL4=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel oops with latest git v2.6.29-9516-g0221c81
Date: Mon, 6 Apr 2009 22:34:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-final; KDE/4.2.2; x86_64; ; )
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49DA6168.2020701@gmail.com>
In-Reply-To: <49DA6168.2020701@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904062234.29481.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 of April 2009, Riccardo Magliocchetti wrote:
> Hi,
>
> i've updated the kernel to latest git and now it's oopsing.
>
> I've uploaded 3 pictures taken from a camera here:
>
> http://yfrog.com/41oops1j
> http://yfrog.com/bcoops2j
> http://yfrog.com/bcoops3j

You hit the same thing as me:
http://lkml.org/lkml/2009/4/6/93

I think that Arjan could tell us something about that problem (CC).

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

