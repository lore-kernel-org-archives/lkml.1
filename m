Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYGGJTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYGGJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGGJTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:19:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:8801 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYGGJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kjqNgaHeOtEYH0bi19/ccJ7aM9tSKAbc661StbK2evB79P56kSzLU49NruouYvCP5x
         xTpjvwLjPLL77nq2muxcLXYnwksdGISREjDe4Rp+UPvVJPo1EEejznme97JP235jTKoD
         xPWJ84/joKo9gCe3FAUOCHSewiPb3BJjzdjCE=
Message-ID: <a4423d670807070219s2dd43aaia29713f5076ecd0d@mail.gmail.com>
Date: Mon, 7 Jul 2008 13:19:05 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a4423d670806201636n4f3d107bk290ed831eb5eefb4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670806201542o5415cad7p6b9a38b67252cee1@mail.gmail.com>
	 <20080620.155139.224032701.davem@davemloft.net>
	 <a4423d670806201612g3487325cj175f077fbe71de2a@mail.gmail.com>
	 <20080620.162135.203810660.davem@davemloft.net>
	 <a4423d670806201636n4f3d107bk290ed831eb5eefb4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

Is it possible to add some debug code to understand what is going on?
