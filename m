Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbXHJKBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbXHJKBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXHJKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:01:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:22964 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527AbXHJKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tP9U6KY6X8L6JKWwbKQPLx8E+TMZAmA4/V1uYGvHP89cNEvtH1dgVdIVPY/PewJCSV9jDej+KO1QkqPJrzQAb8czqQgOVnjLuiCN94ciI0HxLApxAczrcVC8dskn0ygX2VIDiAHmpiNHW40qGRC4nxaSUYREwrilnLPtCE/1TUo=
Message-ID: <a06c13a20708100301g437d93cdp47beac4ca1c301a0@mail.gmail.com>
Date: Fri, 10 Aug 2007 18:01:33 +0800
From: "ES L" <esrndmail@gmail.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: 2.6.12 Kernel Panic
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all linux kernel experts,

Do help me asap as this is an urgent case. I'd compiled 2.6.12 linux
fedora kernel and I encountered kernel panic when i boot it. My
machine is Dell Optiplex GX520. This is the error message:

  umount /sys failed : 16
  mount: error 6 mounting ext2
  mount: error 2 mounting none
  switchroot: mount failed: 22
  umount /initrd/dev failed: 2
  Kernel panic - not syncing: Attempted to kill init!

Thank you very much for your prompt rescue!

Regards,
Lin
