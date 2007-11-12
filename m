Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbXKLOkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbXKLOkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXKLOkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:40:00 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:58039 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXKLOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:39:59 -0500
Message-ID: <473865BE.2070806@checkpoint.com>
Date: Mon, 12 Nov 2007 16:39:58 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PAGE_SIZE on 64bit and 32bit machines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to my knowledge the PAGE_SIZE on 32bit architectures in 4KB. 
Logically, the PAGE_SIZE on 64bit architectures should be 8KB. That's at 
least the way I understand it. However, looking at the kernel code of 
x86_64, I see the PAGE_SIZE is 4KB.


Can anyone explain to me what am I missing here?


Thanks

