Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZHTP0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZHTP0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZHTP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:26:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63185 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZHTP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aBNYEGir2fyil7bI/YpzxL5/oqOonCzgT4+saPCp3Xe5DWU93l8YNGgjkp0Xw5ixS3
         V4/ujx50hMPhcIydeiZBYJyhu519qzziyPp3QMj3ZayVS2io0nGiVJHKtbhqTke46ocz
         pqeFIC9WPkgpL+fjZHkPpLb+Vgpb9LH/StAzA=
MIME-Version: 1.0
Date: Thu, 20 Aug 2009 18:56:07 +0330
Message-ID: <b8931ce60908200826k6d0e8ac8oc4d689b8a89fb09c@mail.gmail.com>
Subject: 2.6.30.4 and nvidia driver will disable changing the bright of 
	macbook monitor
From: nima sahraneshin <unix.nima@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a macbook 5.1 . I installed a kernel 2.6.30.4 then i could
change the bright of monitor but when i installed
NVIDIA-Linux-x86-185.18.31-pkg1.run on 2.6.30.4 kernel  changing the
bright was not work. ( I can't change the bright when using nvidia
driver . without it changing the bright is good).

i used Linux Mint
