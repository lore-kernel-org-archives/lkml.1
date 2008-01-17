Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYAQCVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYAQCVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYAQCVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:21:30 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:40738 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYAQCV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:21:29 -0500
Date: Wed, 16 Jan 2008 21:20:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <200801161211.25948.caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.58.0801162119360.19540@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>
 <Pine.LNX.4.58.0801152259200.19680@gandalf.stny.rr.com>
 <200801160912.37814.caglar@pardus.org.tr> <200801161211.25948.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas, can you look at this. He's getting APIC errors on bootup. I'm
wondering if this isn't another strange anomaly of this controller.

He also states that he doesn't get this with the non-rt kernel.

>
> -rt3 on top of 2.6.24-rc8 works fine without that sysfs problem (acpi warnings
> still there and full dmesg can be found from [1]), whatever causes this seems
> solved :)
>
> [1] http://cekirdek.pardus.org.tr/~caglar/dmesg.rt3

-- Steve

