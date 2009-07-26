Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZGZXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZGZXXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZGZXXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:23:34 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:65098 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbZGZXXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:23:33 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13659] iwlagn (4965): no wireless due to RFKILL problem
Date: Mon, 27 Jul 2009 01:23:29 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.2_E.TIObKB@chimera>
In-Reply-To: <3zAHs5O6maO.A.2_E.TIObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907270123.31384.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jul 2009 23:23:32.0650 (UTC) FILETIME=[176660A0:01CA0E48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13659
> Subject	: iwlagn (4965): no wireless due to RFKILL problem

Fixed in mainline by: 76d8b64e536362e16e38ee1c279c965ebfe094cc

Cheers,
FJP
