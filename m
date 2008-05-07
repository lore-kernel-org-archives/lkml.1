Return-Path: <linux-kernel-owner+w=401wt.eu-S1762569AbYEGW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762569AbYEGW1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbYEGW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:26:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:49010 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570AbYEGW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ttdjgUYvQSAKk+o/85My9B0QdUqkT4SXockBtDN0cvqn6Urqhhj4+FoiwlxNp1hiKgiKMDuxayE23ckwKKFuBAD69sLv2JfHJBJA1GkTDp/IUkUROInMgY7e+tTr/wn3ddzI9hwG0Cz5zE0n58ErqsvysustSvcpa7a+DqDQlxI=
Message-ID: <86802c440805071526s53c4542co6d08704d0364147@mail.gmail.com>
Date: Wed, 7 May 2008 15:26:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Adrian Bunk" <bunk@kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <20080507221435.GH18516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210A71.1060409@keyaccess.nl>
	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	 <20080507124650.GD29935@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	 <20080507212343.GB14951@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
	 <20080507221435.GH18516@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  1) it has empty changelog (come on, "review" a patch and not notice
>  that changelog is empty?!)

the title is good enough

YH
