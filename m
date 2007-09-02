Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXIBXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXIBXS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXIBXSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 19:18:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:54581 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXIBXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 19:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mYgLmZduYFmWMjB8j+CzY7IysoQAJxNVmCNiuEf1bkWl44XKLKzJZQJ9CwZrxhjL9z2C5ILbp6Qngzh2rk6S4rEcluH++7wLDF8Jd5GmnrfiSZyc27/hzlON8uiyt/vKvnyqId3ZDrWbPB6bKg5gAqRFjyGal8mHEuPMJxnEF6Q=
Message-ID: <20cbb9450709021618o42ae8047k10e52e880c97a0a8@mail.gmail.com>
Date: Mon, 3 Sep 2007 04:18:47 +0500
From: "Shahbaz Khan" <shaz.linux@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, selinux@tyco.nsa.gov
Subject: Get source and destination info
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to figure out what part in the kernel code is the point
from where I can get source and destination ip-address, port, security
labels (selinux etc) from a packet before I export it to application
space for my needs. Any hints?

Shaz.
