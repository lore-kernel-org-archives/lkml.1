Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbZHJS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbZHJS4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZHJS4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:56:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZHJS4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:56:19 -0400
From: Martin Rogge <marogge@onlinehome.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13945] Kernel freezes dual pentium-3 system
Date: Mon, 10 Aug 2009 20:57:55 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.30.4; KDE/4.2.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "devzero" <devzero@web.de>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera> <pRuaDVjxFBG.A.plE.YD2fKB@chimera>
In-Reply-To: <pRuaDVjxFBG.A.plE.YD2fKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908102057.55825.marogge@onlinehome.de>
X-Provags-ID: V01U2FsdGVkX1924Im0MUkl76Ai3veQS+bBIvqc+BoLTAnYdAe
 M/4XgEr/+N2EFMaH2J0pMvEj99EkfvcARRlOh8ovn6xf99p+9j
 7ehBq4Ifyvez2UTqtJbAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009 23:10:35 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13945
> Subject		: Kernel freezes dual pentium-3 system
> Submitter	: Martin Rogge <marogge@onlinehome.de>
> Date		: 2009-08-03 16:25 (7 days old)
> References	: http://marc.info/?l=linux-kernel&m=124931667320530&w=4

Hi Rafael,

yes the regression should still be listed. You may want to merge the bugzilla 
IDs 13945 and 13933 as they both refer to the same issue.

Martin

