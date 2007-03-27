Return-Path: <linux-kernel-owner+w=401wt.eu-S934158AbXC0Skv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158AbXC0Skv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934168AbXC0Skv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:40:51 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158AbXC0Sku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=V80U9Ur5n11dVFVFw249bF1eNtnP3eHWvB4rxUOxBd5nh7g7X+ut9DhHAh/YLA6XnlwPEpSIFvVA9hxzW2p/3VMhRMRHBkUbsU05hKY0Yu0ohYwP8MRQhwXa4Q9RHpBVjz0Ut9epsgv1Ow3B0CvS8bLpR0kI8BBZSaGTddez8rE=
Message-ID: <2fe399760703271140l703c2791oa84e9e1832487dcb@mail.gmail.com>
Date: Tue, 27 Mar 2007 11:40:48 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Odd log message associated with NFS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently running 2.6.21-rc5 and I am seeing quite a bit of this
message in my log files:
kernel: rpcsvc: received unknown control message:-2144992132/-1

This machine is an dual dual core opteron with 3Ware 9650 (14 disk
RAID10), 4G RAM, 64bit kernel, nfsutils-1.0.12 running knfsd.  This
machine is a  file server.

I checked google and found nothing that seemed related and I ran a
ethereal looking for anything  out of the ordinary to no avail.

Any help is greatly appreciated.
TIA!
Phy
