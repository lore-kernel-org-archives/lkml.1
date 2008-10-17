Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYJQRNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYJQRNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYJQRNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:13:06 -0400
Received: from ag-out-0708.google.com ([72.14.246.243]:17735 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYJQRNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d+yigGkhwvH63y/q2Uslqyvw3k41Dp31Me5Uhe0Sv+JDTRTNIeDuoL6kkLT90yS6DI
         Pozg/MaJK1SPP+xNNQhGmsJTh8d7chKU3e8vtQ0i4i53boHuAl8Cpmz97HO/IiMLkjSY
         IYhauJX7txsnJMbDJt45StSJtQUwwD2Caak6s=
Message-ID: <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
Date: Fri, 17 Oct 2008 21:13:04 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081017165738.GA20818@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
	 <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <20081017165738.GA20818@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/17 Christoph Hellwig <hch@infradead.org>:
> Very strange.  Can you retry with tomorrow Linux-next which should have
> a large XFS update?  If it still happens I'll investigate it in more
> detail.

I have tried next-20081016 with the same result.
I am afraid I wont be able to test it tomorrow, it will likely be
possible on Monday.
