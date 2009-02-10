Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZBJHrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZBJHrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZBJHrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:47:13 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:25364 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZBJHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fxmhg3dwjC/xMWgFNIHpAejYVBZhVezAq47V+/uinjAp1+roGsfJCECy6iOeUrL471
         mX0KQ725JO101X1lpYl0R13/m8X05n0kFdWQvQ0B5DTSO4i2HooBId65QBKwvFHfnie3
         Tap1MDVJnVYNvLPUAR4wD7pxywm87MW6BV3Tw=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 05:47:11 -0200
Message-ID: <cc0fa41f0902092347g16ed3454ue6af25364ddf0e07@mail.gmail.com>
Subject: Re: X200: Resume and iwlwifi on 2.6.29-rc4-ikn-00001-gd5b5623
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've the same problem here. After suspend i cannot use wireless anymore.
I just didn't tried to rmmod/modprobe to see if it works again. Have you tried?

alemao@dub:~$ lspci | grep AGN
0c:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN
[Shiloh] Network Connection
