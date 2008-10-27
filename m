Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYJ0VAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYJ0VAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYJ0U77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:59:59 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44151 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYJ0U76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:59:58 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Date: Mon, 27 Oct 2008 21:59:52 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com, kernel@nn7.de
References: <20081027162054.GA4015@localhost.aei.mpg.de>
In-Reply-To: <20081027162054.GA4015@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272159.52947.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 27. Oktober 2008 schrieb Carlos R. Mafra:
> Hi,
> 
> So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> when moving to new BSS") by Tomas Winkler (Cc:-ed).

I was also bisecting a suspend to RAM regression in 2.6.28-rc1 but I had to 
stop the bisect due to another problem in that bisection. I can confirm that 
this patch was among the ~50 patches left to test.

Christian
