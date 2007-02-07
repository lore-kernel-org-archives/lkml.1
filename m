Return-Path: <linux-kernel-owner+w=401wt.eu-S1030238AbXBGNQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238AbXBGNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030289AbXBGNQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:16:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:62545 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030238AbXBGNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Lxun8IOjEpxYC9mYD7Ie+2M/ta8YI/E6JztmpWVMs2fxTE2XejfYkxZ4ky6lsd5TCrUHmVTPNyk+ZiJKXScDdyQHE2cvYKSb3bxbQPeJT5BnnDAphqdQG2AUIfTeyESn1gwKjafEWvWTdRu1A4hc6jFrFtUxJaD84rlOm3aDzrU=
Message-ID: <7783925d0702070516o605b42f9tf917df60934d348@mail.gmail.com>
Date: Wed, 7 Feb 2007 18:46:23 +0530
From: "Rick Brown" <rick.brown.3@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       linux-newbie@vger.kernel.org
Subject: Determining amout a physical RAM my kernel needs?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I have a kernel image about 600 KB in size that I intend to program to
flash memory on my target board (hence size required in flash=600 KB).

1) But how do I determine the size of the RAM required to run that
image? (Since I believe the image will be uncompressed in RAM, plus
will also need some extra memory)? Can I determine this info from the
kernel image / System.map etc?

2) Also, is there any way to determine (accurately) the amount of RAM
eaten up by the kernel (plus modules), on a RUNNING system?

TIA,

Rick
