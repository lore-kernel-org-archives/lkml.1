Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbXEXHxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbXEXHxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXEXHxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:53:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:25835 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbXEXHxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AsAoCkW26yIClaS6PXy++juzRXAPeVLU0WIKyj6z7HYwimz4ESK0yGisjzAcBwYwmtXlrvX4AwUiGH6sqq7gIOwbUARDSnT/Ob1eA9FXsvInvubETi4nItbel7WLWSRtTI0Vw37YxFyiYrno/3ejTpW2NnyRUo9J+0ZajH34W8M=
Message-ID: <7fddb68d0705240053n54a96606u238a37e3a265b23c@mail.gmail.com>
Date: Thu, 24 May 2007 09:53:31 +0200
From: "Amaury De Ganseman" <amaury.deganseman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.2 and vfat
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 2.6.21 I can't mount my usb key (vfat).
I don't know if it's related to the vfat patch in 2.6.21.2....

Here is the dmesg error parts:

FAT: invalid media value (0xb9)
VFS: Can't find a valid FAT filesystem on dev sdc.


Tell me if you need more infos.


Amaury
