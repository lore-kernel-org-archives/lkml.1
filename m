Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZI3PrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZI3PrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZI3PrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:47:20 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:53991 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbZI3PrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:47:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=U5lBM0frPAxEANsEvrn8UAaO4HY/Bh+mdZH6ZCqAEV5UkkvTufI+UVGhJ+900T2q;
  h=Message-ID:Date:From:Reply-To:To:Subject:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-ID: <11186255.1254325641912.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Wed, 30 Sep 2009 11:47:21 -0400 (EDT)
From: "Steven A. DuChene" <linux-clusters@mindspring.com>
Reply-To: "Steven A. DuChene" <linux-clusters@mindspring.com>
To: linux-kernel@vger.kernel.org
Subject: Re: newer non-distro kernels don't boot / unpack?
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: EarthLink Zoo Mail 1.0
X-ELNK-Trace: ea4808abc3da2865808dd114cae72f675e89bb4777695beb00ff6c36d42eb1fac65650f18b8fe3b0f5eabbf1b0843d54350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 209.86.224.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, I screwed up and did not include one additional line I see
during the failed boot up of my self compiled kernels.
So the actual messages are:

Booting 'deskamd30mne (2.6.31.1-amddesk1)'

root (hd0,0)
Filesystem type is ext2fs, partition type 0x83
kernel /vmlinux-2.5.31.1-amddesk1 ro root=/dev/sda3 rhgb quiet
[Linux-bzImage, setup=0x3000, size=0x2815c0]

--
Steven DuChene


