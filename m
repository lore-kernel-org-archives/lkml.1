Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYEUEFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYEUEFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYEUEFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:05:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47572 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYEUEFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pFEZLJN/itQ3NL+bLLAkIvLaJZbi0G0M+r5MoJprJw2gYhrnzmSeE9QAOuXG7j+fi6ut7tHVkSGzxXYINixoM4rmd4smMGPjdlpvgjc/AaO3qH5KImaUM1brJ69cAwjaPaumnnv6xanZEzjr/xtNsztZOY+YUjCDjS/H23IU9QI=
Message-ID: <6f4bf7350805202105g2594d85dt1ae3b650e3e3671@mail.gmail.com>
Date: Wed, 21 May 2008 12:05:30 +0800
From: "XiongJia Le" <lexiongjia@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: How to filter the Block I/O in 2.6 kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to filter the Block I/O in 2.6 kernel?

I have looked some in blktrace.
blktrace can trace the block device I/O info. But that can't
filter/change this I/O.

Is the Linux kernel have any way to filter/change a block i/o before
it write to hard disk?
I don't want to change kernel code and re-build. Is Kernel already
have any I/O filter interface?

Thanks,
Xiongjia Le
