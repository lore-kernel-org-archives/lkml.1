Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZGUWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZGUWoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZGUWoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:44:20 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:52839 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZGUWoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SiUlBRixsAdY671ZBgc6zaqvm1FZWu90vNOjGuXOlzfS/HJIY8eoOB7TBXwpHy04n5
         V6te3aOFJC0LtzCQeMR6AGVGn78JDfgFEY0Q9AiV8yoAu7HnMWUVC9uuZ+5VfHUQm2yL
         8YmseCB8YFOc53uW2/jbUZ/RZm+WrIkmnUOyU=
MIME-Version: 1.0
In-Reply-To: <200907212235.47006.marek.vasut@gmail.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
	 <63386a3d0907211328v3c060012r3acc2d5f88e4d9eb@mail.gmail.com>
	 <200907212235.47006.marek.vasut@gmail.com>
Date: Wed, 22 Jul 2009 00:44:18 +0200
Message-ID: <63386a3d0907211544m11eb3a55j1a3b51d9aad27852@mail.gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Marek Vasut <marek.vasut@gmail.com>:
>> * Mailing this to Andrew Morton and LKML since the previous MMC
>>   maintainer stepped down.

> Pierre gave up on mmc subsystem maintainance ?

Sadly yes:
http://lkml.org/lkml/2009/7/14/134

:-(

Linus Walleij
