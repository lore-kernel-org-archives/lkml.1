Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZGWHwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZGWHwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGWHwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:52:15 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56486 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZGWHwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:52:14 -0400
Message-ID: <4A6816AD.2060700@msgid.tls.msk.ru>
Date: Thu, 23 Jul 2009 11:52:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: This combination of AMDprocessors is not suitable for SMP?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(yes there's no typo in $subject, it's an old formatting
bug in printk).

When booting kvm guest on an AMD CPU, guest kernel prints
this warning:

  WARNING: This combination of AMDprocessors is not suitable for SMP.

be it SMP or UP guest.  What's wrong with this "combination",
and can it be fixed?

Thanks!

/mjt
