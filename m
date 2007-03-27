Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXC0Qqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXC0Qqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbXC0Qqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:46:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20911 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXC0Qqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:46:42 -0400
Date: Tue, 27 Mar 2007 09:46:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.21-rc5
Message-Id: <20070327094623.417014db.randy.dunlap@oracle.com>
In-Reply-To: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
References: <1175012677.3737.18.camel@mulgrave.il.steeleye.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 11:24:37 -0500 James Bottomley wrote:

> This is a fairly basic rollup of 3 basic double free or oops based bug
> fixes.


It's disappointing that kernel-doc fixes are not being merged.
Yes, they are not code bug fixes, but they are doc bug fixes,
and some of us do work to try to keep them in good shape.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
