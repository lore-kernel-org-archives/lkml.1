Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab0BDT6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:58:09 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63769 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab0BDT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dC0RVJuhMj5gxEOAB6mFxfnMyIchsuDoByOcvJ15qnhN9/WnVNm//tE/dVuXTqZmRo
         Iov2NwqnEid+VJqqPQi6iGsgCqnvIXOcz0//ovsZ/lC/o00VfKU7UG6nIwxgrlMm+AiM
         D+5QMCvGN0T39ZuJrlObyMBg0wYVNmSIX3qN8=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
In-Reply-To: <201002042049.31582.s.L-H@gmx.de>
References: <1265060041850@kroah.org> <201002041931.40493.s.L-H@gmx.de>
	 <1265308725.4651.14.camel@bigi>  <201002042049.31582.s.L-H@gmx.de>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 14:57:51 -0500
Message-Id: <1265313471.4651.21.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can you try the little patch i sent? I think it fixes it.
BTW, thanks for your perseverance in chasing things - it motivated
me to look closer....

cheers,
jamal


