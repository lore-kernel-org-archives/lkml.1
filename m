Return-Path: <linux-kernel-owner+w=401wt.eu-S935033AbXHGQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033AbXHGQ2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXHGQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:28:31 -0400
Received: from emulex.emulex.com ([138.239.112.1]:34887 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXHGQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:28:30 -0400
Message-ID: <46B89D77.9000506@emulex.com>
Date: Tue, 07 Aug 2007 12:27:35 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <46B89899.5020303@garzik.org>
In-Reply-To: <46B89899.5020303@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 16:27:37.0845 (UTC) FILETIME=[DE2B1250:01C7D90F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> The lpfc update was probably the biggest thing, LOC-wise.  And even 
> though that was mostly bug fixes -- and notably NOT 100% fixes -- it is 
> big enough to warrant integration testing and exposure prior to 
> mainline.  Definitely merge-window-open material AFAICS.

FYI - it is integrated and tested prior to mainline, by Emulex (and who
else *really* tests it close to the degree we do ?). We do so, as a whole,
weeks ahead of the submit to the maintainer. Usually, there's only a couple
of small api changes that are picked up when we merge into the maintainers
pool.  And most of these are caught by us prior anyway as we package the
patchsets and ensure the integration into the maintainers pool is smooth.

-- james s

