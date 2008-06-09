Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYFIKHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYFIKHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYFIKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:07:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42256 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728AbYFIKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:07:24 -0400
Date: Mon, 9 Jun 2008 13:07:23 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "=?utf-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10823] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <dCRO4tbfLzK.A._ED.02vSIB@albercik>
Message-ID: <Pine.LNX.4.64.0806091305110.16829@wrl-59.cs.helsinki.fi>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A._ED.02vSIB@albercik>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-843103139-1213006043=:16829"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-843103139-1213006043=:16829
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 7 Jun 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10823
> Subject		: stuck localhost TCP connections, v2.6.26-rc3+
> Submitter	: Ingo Molnar <mingo@elte.hu>
> Date		: 2008-05-26 11:56 (13 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121180311931349&amp;w=4
> Handled-By	: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

This should still be listed. We have a potential patch but testing of it 
might have hit another bug with similar symptoms. Also a known to working 
revert exists. ...But neither is in mainline / net-2.6 yet.

-- 
 i.
---696208474-843103139-1213006043=:16829--
