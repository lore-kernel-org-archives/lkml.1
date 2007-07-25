Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbXGYGmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbXGYGmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXGYGmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:42:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:46984 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXGYGmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LjEq6rbq58qtr+YF/+5GUV+mxTX5NiuxSz+OC0qSl1CLvnRXhRSIP6m0It/d4UAhFU8ryLWNxRybXd7/ZR7uZKclSyvLTJ0Jv4OBsBUhvYctzeTZKGSjJigBwCYIoyKEEwbSvhwrGrVBbxY/U5I8cQTQr7C5CuJS0Iypu2SsH2g=
Message-ID: <a8e1da0707242342s31166a5ax602fbcde8a299c97@mail.gmail.com>
Date: Wed, 25 Jul 2007 06:42:38 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: kai@germaschewski.name, sam@ravnborg.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: make randconfig improvement
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
IMHO, the randconfig option make no sense sometimes. For me, My
computer need some must-have config options, like SATA and USB
keyboard config options. I think many other people maybe have similar
problems.

So, what about improve the randconfig?  let's add some basic options ,
like oldconfig.   We can use randconfig based user-defined options,
randing except the pre-defined ones.

What's your opinons?
