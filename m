Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZJ1UNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZJ1UNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZJ1UNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:13:52 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:46773 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbZJ1UNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sP4YHG3DsvLg+Yxxm1e0/R/a3Bo3Te8/3mrdTk8F4TfEny97kvREqM0hdHXA1JIVPj
         CkW8T7UNPaGVk5y5MBRYnFz8AZD9/+NM6u9Nx4ungmblRs9FTFM2IG4JakTW3R/HFYkt
         AgpNxQVIjAWm7Od23hLc9eUg/ud6dqGBB/0xU=
MIME-Version: 1.0
Date: Wed, 28 Oct 2009 13:13:56 -0700
Message-ID: <86802c440910281313h2ca89c94w99121edffbf6ce53@mail.gmail.com>
Subject: nfs broken in net-next?
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pk12-3214-189-102:~ # mount -t nfs 10.6.75.100:/data/shared/pxeboot /x
mount.nfs: rpc.statd is not running but is required for remote locking.
mount.nfs: Either use '-o nolock' to keep locks local, or start statd.


using opensuse11.1

YH
