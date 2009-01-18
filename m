Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZARU72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZARU72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZARU7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:59:16 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:30732 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbZARU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:59:16 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git patches] libata hibernation fixes
Date: Sun, 18 Jan 2009 21:59:11 +0100
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901181120.08992.elendil@planet.nl> <200901182125.04060.rjw@sisk.pl>
In-Reply-To: <200901182125.04060.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901182159.13329.elendil@planet.nl>
X-OriginalArrivalTime: 18 Jan 2009 20:59:13.0989 (UTC) FILETIME=[9E5CCF50:01C979AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Rafael J. Wysocki wrote:
> > I get two warnings when compiling your patch with this correction on
> > top:
>
> Hm, there were more patches than one, so I'm not sure.  When I apply
> all of them, I don't see these error, but perhaps I should resend the
> entire series. Will do tomorrow.

It's possible that I do not have the very latest version of your patches. 
If you send your latest version I'll check, and test them.

Thanks,
FJP

P.S. .29-rc2 is failing both STR and STD on my HP 2510p :-(
     Will mail details sometime this week.
