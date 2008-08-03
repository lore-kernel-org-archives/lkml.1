Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYHCIBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYHCIBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYHCIBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:01:48 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:2839 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYHCIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iQ7uzEvUMQl7SgoumODbFe1xr3BvHUz5npbLBB7IhRbpX70CHHn9iaXjH+/+AaA3Ga
         DowhCM4QCf4OdsLQ1psow7PVv2XtcdbDrKgqe0vqoAylsjlvoke/VrqLtED+A/kBOM1A
         aMfOj4bhSG86wOsSLCq7Nz9jj7ObMsS3kyjhs=
Message-ID: <a4423d670808030101n12b45272w383355b18004815d@mail.gmail.com>
Date: Sun, 3 Aug 2008 12:01:46 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] drivers/mtd/mtdsuper.c: fix build error
Cc: viro@zeniv.linux.org.uk, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <a4423d670808021652o28607891g12ca137858109449@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080802225304.GD4856@orion>
	 <20080802233240.GA4385@cs181140183.pp.htv.fi>
	 <a4423d670808021640he3ec660k1b5ddfcb6efd1ae5@mail.gmail.com>
	 <20080802234535.GA8929@cs181140183.pp.htv.fi>
	 <a4423d670808021652o28607891g12ca137858109449@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Alexander Beregalov <a.beregalov@gmail.com>:
> 2008/8/3 Adrian Bunk <bunk@kernel.org>:
>> You must store the config of the failed builds somewhere, since
>> otherwise (like in this case) you cannot verify whether a patch
>> actually fixes a problem.
> Right, I have changed this script.
>
Yes, it is CONFIG_BLOCK=n.

Thanks.
