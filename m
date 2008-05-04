Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbYEDJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbYEDJfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYEDJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:35:27 -0400
Received: from ag-out-0708.google.com ([72.14.246.241]:17882 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYEDJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hmWXI2kOedQJ3OCyvPMunnVNvot/+vQSsM5TzNsfofHwO5mGynMOPTh+S0SxQ/eO40/g+GgVecQZb1NCaWXKZd5M73/SBva4hW467JhzLAeZy80ZH5ufHWy4q+SiyoZbeirbSmnZQtUH+s5NsqZnikRnXbJ0MbNCPA54e0//HWI=
Message-ID: <a8e1da0805040235x7bcef348u6930ef1dbc270be8@mail.gmail.com>
Date: Sun, 4 May 2008 17:35:24 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: futex_fd obsolete?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/futex.c :

       printk(KERN_WARNING "Process `%s' used FUTEX_FD, which "
                       "will be removed from the kernel in June 2007\n",
                       current->comm);

Do we need to remove the function?

Regards
sdave
