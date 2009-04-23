Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZDWJyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZDWJyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZDWJy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:54:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:45635 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZDWJyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pnKfJPHEBD46E3h4NBPrceHkilNS9uC0gCXtcxnwRgs9p/rkR/J+bHwjDt2T99Z2qv
         RIgtMUN+J3XOOhFU6lbeGaTYLg/eIhvIYzW20ieYWS1kmmL4j3rUTSUAhnh297nqzsZ3
         D9dlcocZaWHUY7EIDugKRnyTzvlbORsBbfies=
MIME-Version: 1.0
In-Reply-To: <49EEF38D.8000801@in.ibm.com>
References: <20090422154247.dbffd285.sfr@canb.auug.org.au>
	 <49EEF38D.8000801@in.ibm.com>
Date: Thu, 23 Apr 2009 13:54:24 +0400
Message-ID: <a4423d670904230254v672798ddtda443e549ef45490@mail.gmail.com>
Subject: Re: April 22 Next : net/rfkill randconfig failure
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/22 Sachin Sant <sachinp@in.ibm.com>:
> Today's next tree build (x86 randconfig) failed with
>
> net/rfkill/rfkill.c: In function 'update_rfkill_state':
> net/rfkill/rfkill.c:99: error: implicit declaration of function
> 'rfkill_led_trigger'
> make[2]: *** [net/rfkill/rfkill.o] Error 1
>
> .config attached
>

Add CCs
