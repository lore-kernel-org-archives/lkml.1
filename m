Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0BTO2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:28:33 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:63470 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0BTO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JGwbr+Lh6OUCGoi/M5qkCiPXrl+FElvr1JLtwSp8ZAd58z98W6jDAeJvasj2Ls3RdZ
         IUm8KvGSLewCFqi2bA9mogNFsE/Q7iGnGcPOqwOro+ot/Q4xC9uGC7ds8d+7w6brmmak
         N0d3beEBVCcgP6sIS5SCEfr6s+GnGHYE9en44=
Date: Sat, 20 Feb 2010 22:28:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH series] sysctl extern cleanup
Message-ID: <20100220142825.GR3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to tell in subjects:
The sysctl cleanup patch set is based on mmotm 2010-02-11-21-55
