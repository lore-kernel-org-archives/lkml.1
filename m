Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZKHNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZKHNij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZKHNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:38:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:42928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZKHNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z4HNfxpvMScZRS34JQvg0YpaCaKLaOakQFQuUG+lFq90yAxO/tvax/F9ePVeLlenCA
         NlO9HHnJcjRfHgs5YQHdfRsxW2VjRh380hya7Hsc0a1gtZ2QRfovJtqJBgD6PlaKsoU+
         TbT907AdKJBDLPkxvll/IUW7tBhSCfcWkfjQc=
MIME-Version: 1.0
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA05042B1D@chinexm1.ad.analog.com>
References: <1257195888-6122-1-git-send-email-tfransosi@gmail.com>
	 <0F1B54C89D5F954D8535DB252AF412FA05042B1D@chinexm1.ad.analog.com>
Date: Sun, 8 Nov 2009 11:38:43 -0200
Message-ID: <a4c8a6d00911080538y3735e6bbq9c1bdc4ba90e2ead@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] blackfin/trivial: remove 
	duplicatedMAX macro from stamp.
From: Thiago Farina <tfransosi@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: trivial@kernel.org, vapier@gentoo.org,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org, "Song, Barry" <Barry.Song@analog.com>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonic,

On Fri, Nov 6, 2009 at 1:17 AM, Zhang, Sonic <Sonic.Zhang@analog.com> wrote:
> Acked-by: Sonic Zhang<sonic.zhang@analog.com>

Could you apply this to blackfin tree?
