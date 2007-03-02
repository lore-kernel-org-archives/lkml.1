Return-Path: <linux-kernel-owner+w=401wt.eu-S2992693AbXCBSKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992693AbXCBSKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992697AbXCBSKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:10:13 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:27142 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992693AbXCBSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:10:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CAI1yPbX2E10LultKkU6DwvSdLsu0SDj6hoICrp1fcwvqXkwMJaj3N+NYErxqyntrNdH5+jxYT+dL5387pULMh5IJNytiCDefrd9fThx1ytJBGof5l6CvU8Hqq0aKx3PvV+Yzq2tS88EeuAlW/q1FQKBjh3eWo1A63+154nksxY=
Message-ID: <6bffcb0e0703021010s27488f17l26fcd61cec88d012@mail.gmail.com>
Date: Fri, 2 Mar 2007 19:10:08 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jiri Slaby" <lnx4us@gmail.com>
Subject: Re: [PATCH] longhaul pci_find_device -> pci_get_device conversion (was: Re: 2.6.21-rc2-mm1)
Cc: "Dave Jones" <davej@codemonkey.org.uk>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <3888a5cd0703020945r4ca51f3dxe981050b817e7594@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	 <45E84E81.5080002@googlemail.com>
	 <3888a5cd0703020945r4ca51f3dxe981050b817e7594@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/07, Jiri Slaby <lnx4us@gmail.com> wrote:
> missing pci_dev_put()s

Yes.

Please ignore this patch.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
