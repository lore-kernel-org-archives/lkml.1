Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZFZOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZFZOfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZFZOfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:35:32 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:54911 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760483AbZFZOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cLJomGps/qUqn6xMPpyFctEya1ENMw2vCPxTyZWw2jHKtfBqehugUQfDZz/d0nerdP
         6/OUIrtWRWWITPbXUldJhqPoQTs4PsKMeLUQPT+kqkkrGG7s7XPfgXGV8SmYh1fgy+To
         OBKOzt4MLxHGrICOjedCLWXsSHlv3upyZ+x/4=
MIME-Version: 1.0
In-Reply-To: <20090626150856.7b5fafb2@lxorguk.ukuu.org.uk>
References: <b08bcbf50906260704s11181158r27d88e2dd518b1e9@mail.gmail.com>
	 <20090626150856.7b5fafb2@lxorguk.ukuu.org.uk>
Date: Fri, 26 Jun 2009 16:35:25 +0200
Message-ID: <b08bcbf50906260735q6af6522dl6f1bb407f68a801e@mail.gmail.com>
Subject: Re: Kernel hard_start_xmit performance vs SOCK_RAW performance
From: Gallus <gall.cwpl@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Fri, 26 Jun 2009 16:04:04 +0200
> Gallus <gall.cwpl@gmail.com> wrote:
>
>> Hi,
>> what path would you choose to rapidly generate packets
>
> Documentation/networking/pktgen.txt

Thank you Alan for the answer.

However, my goal is to generate packets with certain *content* in them.

-- 
Regards,
Gallus
please CC me
