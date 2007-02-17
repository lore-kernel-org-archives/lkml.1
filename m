Return-Path: <linux-kernel-owner+w=401wt.eu-S964832AbXBQXGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbXBQXGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964910AbXBQXGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:06:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:25802 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbXBQXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cWDFHoAFDGqtljMAxfvq4juYWOZOfKCYEmWG9oLqFrzAB/ZAUV/NCxJdScGj0gTU3EBKO2Q7u1OhVZIIvgzNQ95v9reF9zRVVVsZK9AMNDeKPT1oLK53pzu8D6Wiv0ig/FSUVgypbEw6u4C8cPtBKbKv4e0f0o6Mhp1UEYtmTYk=
Message-ID: <6bffcb0e0702171506u68c26be0u3c8fabeb21c125ee@mail.gmail.com>
Date: Sun, 18 Feb 2007 00:06:46 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-git14 rtl8139 possible circular locking dependency detected
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20070217221252.GA16954@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D7569F.9030502@googlemail.com>
	 <20070217221252.GA16954@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/07, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> :
> [...]
>
> Did you enable RTL8139_DEBUG ?
>
> If so you can try the patch below.
>

I enabled debugging
#define RTL8139_DEBUG 3

Here is a full log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20-git14/bug.txt
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20-git14/git-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
