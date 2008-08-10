Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYHJGCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYHJGCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYHJGB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:01:58 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:39672 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYHJGB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:01:58 -0400
Date: Sun, 10 Aug 2008 08:01:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [Bug #11230] Kconfig no longer outputs a .config with freshly updated defconfigs
Message-ID: <20080810060129.GA5968@uranus.ravnborg.org>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.b8B.sDjnIB@albercik>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.b8B.sDjnIB@albercik>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
> Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
> Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Date		: 2008-08-02 16:03 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4

The originally reported issue is fixed,
but the fix was bad.
Roman have already posted a patch fixing it but I need time
to review/test.

	Sam
