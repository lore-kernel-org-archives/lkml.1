Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZARVOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZARVOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZARVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:14:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:59193 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZARVOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XetCDoGsM12ngbfnm06r+hulyrGYKMqiyH3GmKYyY2VMBowFkATElRfKKTqkzU3pfU
         CyzWZa4bg6LhgaDq3/u5/N8icOyqux1har7uOFnZ/Bn7QaHLzBgXF5Jx/gvEXxv8yiPV
         rHn1JM87BN4zPXb/PkJw7jnOK720mtDciNObE=
Message-ID: <a80c86b70901181314u28e6ed8brc2edfa38f21f991e@mail.gmail.com>
Date: Mon, 19 Jan 2009 02:44:20 +0530
From: "Prateek Donni" <prateek.donni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: system-config-lvm error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recd. this error while trying to resize  root partition thru lvm
using the system-config-lvm utility :

umount command failed. Command attempted: "/bin/umount /" - System
Error Message: umount: /: device is busy
umount: /: device is busy


However using command line it works absolutely fine.
Why does this happen ?
