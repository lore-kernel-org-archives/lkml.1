Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXCTNwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXCTNwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCTNwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:52:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:40221 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211AbXCTNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O19BR30renqhTNdCoP57UAPEuFW0QbmSfwgUzGE5mjaCKHimbM9D4mBmeSHY20mEXNeGXSCXgSZTddTqgy3Srm4T5MWCUCIoLDT0QDleCLOXAmN3v8+ZUuQ48+cpUMJhXBYIkEOlTkr4nr2uzMw+Hc6RvwVhJqcBLpJtxYD2Xik=
Message-ID: <a44ae5cd0703200652q12aa9398if908757174ba1a6@mail.gmail.com>
Date: Tue, 20 Mar 2007 06:52:04 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>
Subject: 2.6.21-rc4-mm1 + 3 hot-fixes -- init/.missing_syscalls.h.cmd:2: *** missing separator. Stop.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I don't see any announcement for 2.6.21-rc4-mm1 on LKML, but I went
ahead and tried it out.  I hit the following, even after running
mrproper.

init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
make: *** [.tmp_vmlinux1] Error 2
