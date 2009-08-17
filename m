Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZHQM6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZHQM6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHQM6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:58:31 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:57465 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZHQM6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:58:30 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Mon, 17 Aug 2009 14:58:30 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera> <pRuaDVjxFBG.A.52F.kF2fKB@chimera>
In-Reply-To: <pRuaDVjxFBG.A.52F.kF2fKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171458.31106.elendil@planet.nl>
X-OriginalArrivalTime: 17 Aug 2009 12:58:31.0639 (UTC) FILETIME=[6C24B670:01CA1F3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> Subject	: Warning 'Invalid throttling state, reset' gets displayed
>		  when it should not be
> Submitter	: Frans Pop <elendil@planet.nl> 
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> 		  http://bugzilla.kernel.org/attachment.cgi?id=21672

I've just submitted the patches through mail:
http://lkml.org/lkml/2009/8/17/169

Maybe that will help.

Cheers,
FJP
