Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXDYM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXDYM3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965483AbXDYM3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:29:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:17039 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965472AbXDYM3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jGjlYp9SYKFB58cCh7/htkJo0arMmkpDHRHvGnQV666UEkfdPDDVELycW/EzU9Fa9a5R2d5+t1Zxh2uW2jd2egQi8mRUhwysdUUonJZw1iBHI/TbS8spDvgWCI9PDRaovlWE1gBxiYjBRcaPj07zPDYN/RKtwW86/LfBbh6MMdE=
Message-ID: <462F4988.8000109@gmail.com>
Date: Wed, 25 Apr 2007 06:28:56 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com> <20070425085432.GD17130@htj.dyndns.org> <20070425093044.GE17130@htj.dyndns.org>
In-Reply-To: <20070425093044.GE17130@htj.dyndns.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Please test this one instead.  Thanks.

Yup, the second patch fixes it.

-Berck
