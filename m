Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbXJaHYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbXJaHYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXJaHYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:24:12 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40766 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXJaHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:24:11 -0400
Message-ID: <47282D7B.3010109@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2007 12:53:39 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Subject: [2.6.24-rc1-git] Warning with make tags and cscope
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Get following warning while building tags and cscope index files

$ make tags -j 2
  MAKE   tags
find: arch/i386: No such file or directory
find: arch/i386: No such file or directory
find: arch/i386: No such file or directory
$ make cscope -j 2
  FILELST cscope.files
find: arch/i386: No such file or directory
  MAKE    cscope.out

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
