Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYHGWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYHGWbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYHGWbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:31:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:9489 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYHGWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NVmDjZwikmbYhhC2DRcJcwbSo3kIrdc3cjmwXaCn7YySy7GpCey1d0s2q50qqPOS8p
         YXKVIGDAkXaGOW3rSlWRqLCaU6m8Gt65lAYI4HtrifWIHtRSbb7JXB7TUbXR03nzezqz
         n5lEF1m7asBtalZAO1XkiFbx5snJZFZpIMhmg=
Message-ID: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com>
Date: Fri, 8 Aug 2008 00:30:59 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Linux 2.6.27-rc2] suspend to disk, libata problem
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have problem with suspend to disk. On 2.6.26.* works fine.

During s2disk i have this messages (with "no_console_suspend" kernel option):
http://unixy.pl/maciek/download/kernel/2.6.27-rc2/img_0005.jpg
(hibernation fails)

Config, dmesg (normal booting):
http://unixy.pl/maciek/download/kernel/2.6.27-rc2/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
