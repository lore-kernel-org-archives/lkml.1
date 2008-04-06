Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYDFUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYDFUOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYDFUNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:13:54 -0400
Received: from ip-58-28-152-52.static-xdsl.xnet.co.nz ([58.28.152.52]:42364
	"EHLO sol.unix.geek.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752786AbYDFUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:13:54 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Apr 2008 16:13:54 EDT
Subject: Re: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it
	to hang
From: Jasper Bryant-Greene <jasper@unix.geek.nz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <pdYe6zNQVl.A.XbB.vIW9HB@albercik>
References: <pdYe6zNQVl.A.XbB.vIW9HB@albercik>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 08:07:19 +1200
Message-Id: <1207512439.7405.1.camel@rhea.unix.geek.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer reproducible on 2.6.25-rc8.

Jasper

On Fri, 2008-04-04 at 01:05 +0200, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
> Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
> Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
> Date		: 2008-02-13 12:25 (51 days old)
> References	: http://lkml.org/lkml/2008/2/13/181
-- 
Jasper Bryant-Greene
jasper@unix.geek.nz

()  ascii ribbon campaign - against html e-mail 
/\  www.asciiribbon.org   - against proprietary attachments

