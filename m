Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZALXxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZALXxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZALXxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:53:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:23383 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZALXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:53:22 -0500
Message-ID: <496BD7ED.1010909@gawab.com>
Date: Mon, 12 Jan 2009 15:53:17 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.tiC.4afaJB@chimera>
In-Reply-To: <nHCfeC0YLrE.A.tiC.4afaJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
> Subject		: Sata soft reset filling log
> Submitter	: Justin Madru <bevicm@dslextreme.com>
> Date		: 2008-12-13 2:07 (30 days old)
> References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4
>
>
>
>   
Yes, I'm still seeing this on .28 and even on .29-rc1.
I checked again and couldn't trigger the regression on a .27 kernel (at 
least with my hardware and config).
So, I'm fairly confident that it's a regression, not just a bug that's 
always been there.
