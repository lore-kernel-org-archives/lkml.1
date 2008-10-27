Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYJ0Re5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYJ0Re5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJ0Ret
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:34:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYJ0Res (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:34:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Date: Mon, 27 Oct 2008 18:39:38 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com, kernel@nn7.de
References: <20081027162054.GA4015@localhost.aei.mpg.de>
In-Reply-To: <20081027162054.GA4015@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271839.39236.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 of October 2008, Carlos R. Mafra wrote:
> Hi,
> 
> So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> when moving to new BSS") by Tomas Winkler (Cc:-ed).
> 
> Unfortunately it doesn't revert cleanly so I can't double check it.

Why are you saying it doesn't revert cleanly?  For me it does revert without
rejects from 2.6.28-rc2.

Thanks,
Rafael
