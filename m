Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZALRDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZALRDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZALRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:03:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:63376 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZALRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:03:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GGVXK/dDN+A38/yULrqS6UqBrJ1Haf4if7K5iZppol666sOhoDWuZLSrOFieewlZ0K
         1MGgwjsdY8IKHe1yk4JBy+tmjHqI0VzN3MN/xrFZyJFn5KrjWySgE5+ZmrdzazsvetYP
         pDiT+WbA/7d8oPZH47ij+VJcinYt4gB8kiB3o=
Message-ID: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
Date: Mon, 12 Jan 2009 22:33:40 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Andy Whitcroft" <apw@canonical.com>, davej@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: scripts/checkpatch.pl: WARNING: patch prefix 'arch' exists, appears to be a -p0 patch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

How to get rid of this warning:

 #./scripts/checkpatch.pl --file arch/x86/kernel/module_32.c
WARNING: patch prefix 'arch' exists, appears to be a -p0 patch

total: 0 errors, 1 warnings, 152 lines checked

arch/x86/kernel/module_32.c has style problems, please review.  If any
of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks
--
JSR
