Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbXGUUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbXGUUA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbXGUUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:00:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:19084 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbXGUUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R/5+ImyKja/evS2G0aRxMwTbSr3rIxLax/pb8WRxXgO5yYeSM0nt4EtTMahm5Ab75iIeq0NiJw2HEz1xUxtlLDQq3ZIHypT6KGusxE5sMwAaNzBETr7gB7LpgBI1gtZNSlzaALlrsx7I6pW6bQTj2TWW898H8KgoMbqG/XLsdLM=
Message-ID: <71a0d6ff0707211300p57f31ec1md4a4848e5580c682@mail.gmail.com>
Date: Sun, 22 Jul 2007 00:00:45 +0400
From: "Alexander Shishkin" <alexander.shishckin@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: from where comes "__moddi3"?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707212134210.21737@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
	 <71a0d6ff0707211233r52192d7aic98d2a307b044eca@mail.gmail.com>
	 <Pine.LNX.4.64.0707212134210.21737@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> v & 0x0F  <=>  v % 16
Indeed. (Why would anyone want to mod/div by 15 anyway?). My bad.

Regards,
-- 
Alex
