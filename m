Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYJJI07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYJJI07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYJJI0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:26:47 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:62167 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYJJI0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TWCKswU4fzpPPdQDdqGTYIDdhvr6D6HQwy5CMuUY/1QWLC2fkoVmNkvFoPyDIN/Vni
         GeXw8+aNsDtRobGMpWtPxFG3E2EzNs9j0/a9Kxiad7XjIXuzY5QRryek9DSps6x30o9x
         NyP1907hOfWrzKFWccdsvOEmhJ85f99glTjNg=
Message-ID: <264b990a0810100126l1029f734x7204f8c42ae21609@mail.gmail.com>
Date: Fri, 10 Oct 2008 15:26:44 +0700
From: "Yudha Harimantoro T" <yudha.ht@gmail.com>
To: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Error : Linux-2.6.27
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
2.6.27 patch and try to build it.

I build with `make oldconfig` and answer any question with default
answer, I just press [enter].
I build with `make`. No error and all compiled.
Then I install with `make modules_install` and `make install`.

After reboot the system I got 'kernel panic'.
This is the error picture :
http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
Is it a bugs?

http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
[2.6.26.6 run well]



Best regards,
Yudha_HT
