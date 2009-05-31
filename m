Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZEaVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZEaVSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZEaVSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 17:18:31 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:51749 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZEaVSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 17:18:30 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Sun, 31 May 2009 23:18:30 +0200
User-Agent: KMail/1.9.9
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.6LD.pIbIKB@chimera>
In-Reply-To: <LEcEO2518_I.A.6LD.pIbIKB@chimera>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905312318.31318.elendil@planet.nl>
X-OriginalArrivalTime: 31 May 2009 21:18:31.0821 (UTC) FILETIME=[596CB3D0:01C9E235]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 May 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> Subject	: Warning 'Invalid throttling state, reset' gets displayed
>		  when it should not be
> Submitter	: Frans Pop <elendil@planet.nl> 
> Date		: 2009-05-26 15:24 (5 days old)

Still valid. I've just added possible patches in bugzilla.

Cheers,
FJP
