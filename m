Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXFUFNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXFUFNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXFUFNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:13:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:11056 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXFUFNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pQ0Sck1Guj+uNVkJXhoF/lEF6xoYLxdfjmBvhsXXG+ZsL4akWLECBVLU27dMyz18cpqsI4/CAJyRSeMcPNHRZlqa7fXvBjnK7iVJ7BQOllHTLe9Zr6GGxPKFZJnBEEaFNuu0OOIFLxVyzEbDDsVY7ygYubIeaLyXW7S0szbXsw0=
Message-ID: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com>
Date: Thu, 21 Jun 2007 13:13:00 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What's does KPROBE_ENTRY mean?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I searched in linux kernel 2.6.10, didn't find it, then I tried
2.6.20, it is there. But I am not familiar with assembly language, so
can anybody kindly explain it, I don't know the difference between
KPROBE_ENTRY and ENTRY, however, I can find both of these items in
some files, such as arch/x86_64/kernel/entry.S.

Thank you.

Regards
Jason Xiao
