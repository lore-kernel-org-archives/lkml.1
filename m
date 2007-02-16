Return-Path: <linux-kernel-owner+w=401wt.eu-S932483AbXBPR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbXBPR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXBPR2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:28:42 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22600 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbXBPR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:28:41 -0500
Date: Fri, 16 Feb 2007 09:24:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: S_NORMAL_ACTIVE, S_CLOSING
Message-Id: <20070216092416.316c32fd.randy.dunlap@oracle.com>
In-Reply-To: <45D5DED2.000004.05550@webmail11.yandex.ru>
References: <45D5DED2.000004.05550@webmail11.yandex.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 19:41:54 +0300 (MSK) Mockern wrote:

> Hello,
> 
> In which header I can find S_NORMAL_ACTIVE and S_CLOSING?
> 
> Thank you


cd top_of_linux_source_tree
find . -name \*\.h | xargs grep -w S_CLOSING

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
