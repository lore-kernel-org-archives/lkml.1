Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZFHLcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZFHLcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZFHLbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:31:53 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:58206 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbZFHLbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:31:52 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Mon, 8 Jun 2009 13:31:51 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       rui.zhang@intel.com, len.brown@intel.com
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.1CH.VZ7KKB@chimera>
In-Reply-To: <D9VoutSOyXP.A.1CH.VZ7KKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081331.52723.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jun 2009 11:31:53.0185 (UTC) FILETIME=[B8B51510:01C9E82C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me
> know (either way).
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> Subject	: Warning 'Invalid throttling state, reset' gets displayed when
> 		  it should not be
> Submitter	: Frans Pop <elendil@planet.nl>  
> Date		: 2009-05-26 15:24 (13 days old)
> Handled-By	: Frans Pop <elendil@planet.nl>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> 		  http://bugzilla.kernel.org/attachment.cgi?id=21672

Issue is still present. Unfortunately I've not yet seen any reaction from 
the maintainers (CCs added) to the patches I proposed.
