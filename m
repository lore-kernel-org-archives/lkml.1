Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXDUJuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXDUJuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXDUJuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:50:24 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:36852 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbXDUJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PSBVveLPmBzhXrota19L5+uF/w4KiBiY32a7cgGM12OqfH3zW+Lx8n0wYcPD/Q7sUJxzEAW7cSrZVRHzEbMDd5Ffeid96u/I9xlcmf/YD3gYvJgwgJhe7q20v90sXUmHTHghqLBlO36tT/0kDHqBeiiBX7OsqHj3QZMB3PtCy7s=
Message-ID: <b637ec0b0704210250u14f7ee6fy8ae20915ebbcf8ee@mail.gmail.com>
Date: Sat, 21 Apr 2007 11:50:21 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: emisca <emisca.ml@gmail.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Chuck Ebbert" <cebbert@redhat.com>, Stephen.Clark@seclark.us,
       "Mark Lord" <liml@rtr.ca>, "Tejun Heo" <htejun@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, 7eggert@gmx.de,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Adrian Bunk" <bunk@stusta.de>, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <414cba4e0704210245l6d9d51c2p683a686ad7d54789@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <88SeR-5Sf-15@gated-at.bofh.it>
	 <20070418160627.7ab77c30@the-village.bc.nu> <46263650.3080705@rtr.ca>
	 <46263859.2060309@gmail.com> <46265089.4000409@rtr.ca>
	 <46265307.7060405@rtr.ca> <4626596E.4040304@seclark.us>
	 <4627ABE9.8090906@redhat.com>
	 <b637ec0b0704201257l24d9e9c8ha31221c9c9d8da3e@mail.gmail.com>
	 <414cba4e0704210245l6d9d51c2p683a686ad7d54789@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 4/21/07, emisca <emisca.ml@gmail.com> wrote:
> So, removing -d halt option solves this problem?
>

According to the halt manpage, -n implies -d (in other words, -d is
not removed at all).
Regards,
Fabio
