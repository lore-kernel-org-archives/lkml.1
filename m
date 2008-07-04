Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYGDOVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYGDOVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYGDOUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:20:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:54387 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYGDOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ffBngGXDGBDjh5Pu6CCglXtgrU1+N50xmemFlct8bdy9EH26ggWyLzqnpNuuIJXh1a
         HRFVraUSLV3pCiB7j8WbiuVgMZ21dKm2otHT7fx9VX8Gi1nds760HeuvT9M1BcmUr4yc
         DHBLpGWOzDrPNlhRubGYebqo0+k1kjuwxN5tY=
Message-ID: <a4423d670807040720o3e8e350ds5c13dfca8e8adc58@mail.gmail.com>
Date: Fri, 4 Jul 2008 18:20:47 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: next-0704: x86_64 panics on booting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


Booting the kernel.

Kernel alive
Kernel really alive
PANIC: early exception 0e rip 10:ffffffff80604f47 error 2 cr2 ffffffffff300000

It is x86_64 SMP (opteron).
