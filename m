Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYFKUcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYFKUcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbYFKUbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:31:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56988 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407AbYFKUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:31:02 -0400
Message-ID: <8381014.1213216239408.JavaMail.oracle@acsmt301.oracle.com>
Date: Wed, 11 Jun 2008 15:30:39 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <dCRO4tbfLzK.A.SAC.G2vSIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.SAC.G2vSIB@albercik>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> This message has been generated automatically as a part of a
> report of recent regressions.
> 
> The following bug entry is on the current list of known
> regressions
> from 2.6.25.  Please verify if it still should be listed.

Yes.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (3 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121270308607116&amp;w=4
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


I'll try to test x86/tip today.

