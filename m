Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbYA1QC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbYA1QC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYA1QCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:02:51 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:37247 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYA1QCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KxfKKigdvSF3J7ZH/8ZTw2wsEV02+AJfYkLRcgtq0KgCj7AQr222CxA1WS0o+cFBrUcQmBOr6jNalMCb4T5H10gg6/rlcQWzkwocmYXFfgasRdAXVjjtuaHS9KJHgFp3Jk8SfuAk6KqiRAYH/M2d9G27rlpo8eXjcb53rJCZk1Y=
Message-ID: <eca31190801280802m6e5b2c4bna4cc567e9935b30c@mail.gmail.com>
Date: Mon, 28 Jan 2008 10:02:29 -0600
From: "Roy Zacharias" <royprogram@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: telnet hanging issues in kernel 2.6.16
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is my first time posting on this list.  Currently, I am working
on a powerpc board and I encounter some problems.  When I do the
following:

1. Login to my card from pc as root
2. Run command (i.e. ls, ps, etc.)
3. Wait 30 min-1hr
4. Run command

After the fourth step, I only see the partial output of the command
and my telnet session becomes unresponsive and I have to connect
again.  This same issue occurs even on ssh leading me to believe that
there is an inherent network driver issue.  I am using the e100
drivers in the 2.6.16 kernel.  Are there any issues with this driver?
Are there any patches for it?  I am running on busybox 1.7.1 with the
eldk 4.1 toolchain.  I appreciate anyone's help.

Thanks,
Royous
