Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZD1V1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZD1V1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZD1V1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:27:44 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41325 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbZD1V1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Jza7yoL3nwHNVwYFn1KYStpyfAYwKMPN1NBkWuj+odlkGxk2GANrTytL4/azfys55R
         W1oHu1aAW4CZgMgNyGmqF5uEPOYZoSZyPzX21QvKg7HlIQhN79TF0QuJLZjO86K40Cpl
         YUudCiaZVREISB7EPsMpNpvK9+d0yX4kLchmo=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 23:27:42 +0200
Message-ID: <2d05c4580904281427r65282bb2m5dd8c9f8a2de5363@mail.gmail.com>
Subject: Debug only with printk ?
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am relatively new in linux kernel and since debugging is key
element of programming, I am wondering is it really necessary
to use various debugging tools for kernel debugging ?

Is simple printing with printk enough to debug any kind of kernel problem,
and if not, what are the cases when printk is not enough ?

Also, is there possibility when using debugging tools to affect
kernel environment, because debugging tool will also take cpu time and
memory resources ?

thanks

Dragoslav Zaric
[Programmer; M Sc Astrophysics]
