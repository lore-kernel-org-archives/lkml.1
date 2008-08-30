Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYH3Rzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYH3Rzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYH3Rzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:55:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:39430 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbYH3Rzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=Jy/D4JgaI/OVj0V26F7qPvu0nISpJVof+RygSJlDVH4dx8T+GgH50jgw6/DuOV6Ha+
         QJQ5/7kZaKn+fufyBOt3IUzR4HsxcvAFmb6c0vYhQo4NyA8HnnSqL9Z0IA3VJs8YNa/s
         MhI/3l5rj+75rLssTzgPFVEpT84ZEIB2kQTP4=
Message-ID: <86802c440808301055o1a8bc6a9iddbc066f016ef6d6@mail.gmail.com>
Date: Sat, 30 Aug 2008 10:55:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <200808301915.00381.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17173_31215933.1220118935945"
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808301532.57307.rjw@sisk.pl>
	 <86802c440808300905v5056fe0apdc6e328d99dff090@mail.gmail.com>
	 <200808301915.00381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17173_31215933.1220118935945
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Aug 30, 2008 at 10:14 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>
> Could you please rebase them on top of current -git?

please check attached quilt series based on linus tree.

YH

------=_Part_17173_31215933.1220118935945
Content-Type: application/x-bzip2; name=reserve_region.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkij5ji30
Content-Disposition: attachment; filename=reserve_region.tar.bz2

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
W8Oo/g==
------=_Part_17173_31215933.1220118935945--
