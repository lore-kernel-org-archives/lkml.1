Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYLVEMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYLVEMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 23:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYLVEL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 23:11:56 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:12115 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbYLVELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 23:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pj9g1/4wVdOSkKYQPtic0Ban/c7eDpreX0RnUXsWJrh/aOtG6UMIbS5Gl36r/ZGWyY
         qWKuJ4Z8gBFnyj3bBd5OqppvhW5mMgw5df/sQjXMUiLJVDd9RXk6+6fJjdWCTKxEDrni
         DjnGocfAAZd2ciDAc8uGajGr6sy1+cngTK/yM=
Message-ID: <aecf5e530812212011n23627e94r52453aca2c9b6089@mail.gmail.com>
Date: Mon, 22 Dec 2008 09:41:52 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: TTY problem on linux-2.6.28-rc7
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have recently moved to linux-2.6.28-rc7 but I am facing problem in
getting console on arm platform when booting through initrd.
On linux-2.6.27 system is working fine.
The problem is that it got hang after the init process started and
when control goes
to user space. The request for tty_open and tty_close keeps on coming.
Because of that the print stops coming on uart after init process.

Does anybody had any idea regarding this?

Regards
Sandeep
