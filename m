Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYELQXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYELQXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYELQXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:23:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:64565 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYELQXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TRxmfNPFeVeC0f03u07NTG18vjYszXF2zCjkCZuqpQZwWEnZkRDNWOLp1kRFnRnEU3pyxBs5M+8bLHkikmTAO3OLgvzINMRfVSCcliHPtwjIiKrPMF6Nn4xZ67wB8ZP5vlohPX7bU++TY/JUuf6lA1VZb/S5G9E10nrSlZ80MEY=
Message-ID: <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
Date: Mon, 12 May 2008 09:23:42 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Bob Zhang" <zhanglinbao@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AXFS is a XIP file system , compared with linear XIP CRAMFS , it is
>  better in efficiency and speed .

Thanks!  I agree.

>  Anyone is doing this work ? Can you share with me ?

Yeah.  I got a copy that works on 2.4.21-ish Montavista CEE like kernels.

I just haven't got around to posting the patches.  Okay, Okay.  You
are the third person to ask.  I'll update sourceforge and repost here.
