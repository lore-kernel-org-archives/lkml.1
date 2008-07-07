Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbYGGP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbYGGP7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYGGP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:59:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:42728 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYGGP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KkDZV68fyvHQD82S9Vwje2veItiyJMJPuWk0aWalosBs68SGtKUVMXS+3C0iyfS6Yu
         ALjJ1nUG5eN0mF9SDGHzD2DLkBk2dI9Z9YxvG7VeDq02phylXaDUDRytxeVxDinnCKLV
         U0J38dTuJm4ZC5mot+QNTkwj4syi+QGgGsBkA=
Message-ID: <a4423d670807070859y74f529b5i60f04e0a37a01cd3@mail.gmail.com>
Date: Mon, 7 Jul 2008 19:59:04 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Cc: "David Miller" <davem@davemloft.net>, kernel-testers@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <18546.5247.797478.66373@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620.162135.203810660.davem@davemloft.net>
	 <a4423d670806201636n4f3d107bk290ed831eb5eefb4@mail.gmail.com>
	 <a4423d670807070219s2dd43aaia29713f5076ecd0d@mail.gmail.com>
	 <20080707.040126.178187777.davem@davemloft.net>
	 <18546.5247.797478.66373@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have turned off LOCKDEP and it boots properly.
2.6.26-rc9-00005-g1b40a89

Mikael's config also does not contain LOCKDEP.
