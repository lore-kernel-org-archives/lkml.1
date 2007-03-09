Return-Path: <linux-kernel-owner+w=401wt.eu-S2993018AbXCIHJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993018AbXCIHJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993026AbXCIHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:09:05 -0500
Received: from [221.6.14.228] ([221.6.14.228]:41272 "EHLO proxy.fnst.com.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993018AbXCIHJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:09:03 -0500
Message-ID: <005a01c76219$d9633350$2801a8c0@zhangxiliang>
From: "zhangxiliang" <zhangxiliang@nanjing-fnst.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: "swapon" function manpage 
Date: Fri, 9 Mar 2007 15:09:16 +0800
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-RFC2646: Format=Flowed; Original
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
  The manpage of "swapon" function since Linux 2.6.17 has some error.
  The MAX_SWAPFILES should be 30 in the latest version. Swap migration uses
the two higest numbers of swap types (30 and 31).

Regards
Zhang Xiliang 



