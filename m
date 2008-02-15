Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbYBOXY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbYBOXY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYBOXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:24:50 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:52343 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYBOXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:24:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PoprYhpgKXkmD+WZH4M/2K+Haz6KbGB7+RZiw4YtMGyEog5e+/mGR+Pn+g59g0OKwbprfbMmGdwuH14wHa5hH/veiwXhQOU3pDoRQqgt5qr1JbdLvDzs/2uxWG+rXUzUB5CPaA14RWurjz1VkXw1gOTl7cd2/7tMeF4uIgfCAzE=
Message-ID: <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com>
Date: Fri, 15 Feb 2008 18:24:47 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <47B61473.7060206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com>
	 <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>
	 <47B61473.7060206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 5:38 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>
> You mean to consider 0 as supported, -ENODEV/-EOPNOTSUPP as
>  unsupported and the rest as error?
>

Yeap, what do you think?

  Luis
