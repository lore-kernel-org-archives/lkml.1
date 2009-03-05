Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZCEMu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZCEMu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZCEMuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:50:13 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:55107 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCEMuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:50:12 -0500
Date: Thu, 5 Mar 2009 12:50:05 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #12762] Disk errors loop forever in 2.6.29
Message-ID: <20090305125005.GA16693@silver.sucs.org>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera> <SLCXkuHtxAO.A.MVC.EVarJB@chimera> <1236118049.24019.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236118049.24019.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 04:07:29PM -0600, James Bottomley wrote:
> In theory, the fix should be upstream here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=126c098296c8f96cf7f6ca0fdb47265ac7994f00
> 
> (not in a released -rc yet, but should be in -rc7).

Yup - just tested -rc7 and the problem is gone. Thanks!

-- 
Sitsofe | http://sucs.org/~sits/
