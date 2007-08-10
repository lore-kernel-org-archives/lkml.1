Return-Path: <linux-kernel-owner+w=401wt.eu-S942268AbXHJVK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942268AbXHJVK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760490AbXHJVKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:10:44 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:55389 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXHJVKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:10:43 -0400
Message-ID: <000a01c7db93$c75b66c0$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Subject: Software based ECC ?
Date: Fri, 10 Aug 2007 23:16:45 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
X-Provags-ID: V01U2FsdGVkX1+ubqfg54NL8Sr47Nzro+IH+mJVUruy9SP3S0Gl
	c+fuGUa1MV0A/D60dUZ0jT220Qt+Nv3+ywBxjpbk7xdNknL9wE
	4C1jXi86Y=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

since ECC (speaking in terms of ram/memory) is some widespread hardware
technology
within server/enterprise computing for protection of memory failure,  i
wonder:

Can`t this be done in software, too ?

I didn`t find a referenc on this list, but i found an interesting paper i'd
like to share at:

http://pdos.csail.mit.edu/papers/softecc:ddopson-meng/softecc_ddopson-meng.pdf

"SoftECC : A System for Software Memory Integrity Checking"

Is it possible to implement something like this within the Linux virtual
memory subsystem ?
If it can be done, wouldn`t this be a great feature ?

regards
Roland K.
system engineer




