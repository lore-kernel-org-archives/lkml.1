Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYEaUKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYEaUKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYEaUJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:09:29 -0400
Received: from smtp.movial.fi ([62.236.91.34]:47432 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbYEaUJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:09:20 -0400
Date: Sat, 31 May 2008 23:09:19 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10841] asm-m32r/uaccess.h must #include &lt;asm/setup.h&gt;
Message-ID: <20080531200919.GH24468@movial.fi>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.2dC.PqZQIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <UJSav77TyUB.A.2dC.PqZQIB@albercik>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 07:48:06PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

yes

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10841
> Subject		: asm-m32r/uaccess.h must #include &lt;asm/setup.h&gt;
> Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
> Date		: 2008-05-31 07:29 (1 days old)
> References	: http://lkml.org/lkml/2008/5/31/87
> Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
> Patch		: http://lkml.org/lkml/2008/5/31/87
