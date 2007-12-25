Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbXLYRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbXLYRE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXLYRER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:04:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:61373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXLYREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HNG+6OslokDP9P41l0iHfbGQqUkqaf0ePKiH1fmn1xnnluiXc0LxiRv0K7CHSQxyv9OrkhVs2CJ4TEeYW2r1Rkr67A0UzGOX1qOCX7JvAZ5FruPfbapv77Fy4rOFp/hEmGoHOA2T2QE1OTSAzKW8jGmANHyz5gfbbi3QU6d/4kM=
Message-ID: <9e0cf0bf0712250904t213d623bp977db54b6be5e3e@mail.gmail.com>
Date: Tue, 25 Dec 2007 19:04:14 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile fail)
Cc: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <4770DE51.5000205@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com>
	 <4770DE51.5000205@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply!

On 12/25/07, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
>     PM code is generally broken and unmaintained, so no wonder. I don't
> remember if anyone has fixed CPU context restoration code (it uses a "skewed"
> stack frame).

So suspend modes on these boards are not supported?
Only "Always On" configuration is supported?
Or there is another method to preserve power?

Best Regards,
Alon Bar-Lev.
