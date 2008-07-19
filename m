Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYGSDjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYGSDjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYGSDjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:39:13 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:37064 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYGSDjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xOuIh+d0Ka7/Zv57lhoLlsC8nYgKm8kNNsKQ9UT0QwzBe/KK955AWNyGOR736I2LTO
         N+8xSre3g5tK5nAyDQ+Ss/hVdL2ALnsXEdLeXtY/FrJ+HS6J/EEVbV/DflluhO+8vO8S
         zyqJoRDuahkiOKftB4re13fKqcIaEgLQUoexA=
Message-ID: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com>
Date: Fri, 18 Jul 2008 20:39:11 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: macbook2,2 latest git mmconfig issues
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
Well I couldn't really see what was happening
until I could experience this myself;
It seems the macbook pro ati chipset
is having the same problem as jack was with mmconfig yesterday.
I'm confused as to why my system was able to run this kernel(2.6.26.git1)
without a problem, now after doing a reinstall of the operating system
I am confronted with this same issue. How do I find the 0x3f number on
my system,
so I could plug that into the patch? to see if I can boot up
Now keep in mind the only difference with this install is the
installer took a dump
therefore you have to manually install grub(could this be the source
of the issue?)
regards;


-- 
Justin P. Mattock
