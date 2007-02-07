Return-Path: <linux-kernel-owner+w=401wt.eu-S1030373AbXBGAYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373AbXBGAYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030443AbXBGAYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:24:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:40986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030335AbXBGAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EiqvmiaKjkf68CbWmIRL8vTxIBenOtPvnmXo9RXlmgzEzd2vHU0/KtbnL5ccQ9Pcel+44fuLPnIgk/oMSb5Rci+L3jJUTsqAz+cnZaGsH5zQI9atIqpUTIkQEpkYFwqiZggubkxZzgz8oUK2hKtOeynD28mJZFklax+mOqaUIbM=
Message-ID: <3400f2f60702061624v69f29cfcme80a0736aa6243e2@mail.gmail.com>
Date: Tue, 6 Feb 2007 18:24:34 -0600
From: "J. K. Cliburn" <jcliburn@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [RFC: -mm patch] drivers/net/atl1/: possible cleanups
Cc: "Jay Cliburn" <jacliburn@bellsouth.net>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@osdl.org>,
       "Xiong Huang" <xiong_huang@attansic.com>,
       "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <45C91BCA.3030108@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <20070206221229.GH27397@stusta.de>
	 <20070206181910.4d27046a@osprey.hogchain.net>
	 <45C91BCA.3030108@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Jeff Garzik <jgarzik@pobox.com> wrote:
> Jay Cliburn wrote:
> > Your patch is just a little bit out ahead of us.  Some of your suggested
> > changes are already in the pipeline; we're just waiting for Jeff to
> > merge netdev#atl1 into netdev#ALL.  Should be soon.
>
>
> Technical note:  merging #atl1 into #ALL happens each time
> netdev-2.6.git is flushed out from my local machine.

Noted.  Thanks.
