Return-Path: <linux-kernel-owner+w=401wt.eu-S1946036AbXEAWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946036AbXEAWs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXEAWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:48:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:63233 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXEAWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="222661572"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Stephen.Clark@seclark.us
Subject: Re: [git patches] libata updates
Date: Tue, 1 May 2007 15:49:03 -0700
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20070429161542.GA12501@havoc.gtf.org> <200705011438.07499.jesse.barnes@intel.com> <4637C30C.5000109@seclark.us>
In-Reply-To: <4637C30C.5000109@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011549.03932.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 1, 2007 3:45 pm Stephen Clark wrote:
> I'm running fc6 but with kernel 2.6.21 from kernel.org - compiled
> with the .config file from fc6.
>
> My system is a asus laptop with an ich7 chipset which has both sata
> and pata controllers. My
> laptop only brings out the pata controller interface and both my hd
> and od are on the second
> channel of the pata.
>
> So can I configure out the old ide and just have ata_piix
> automatically control them both in
> 2.6.21?

Yeah, I think that'll work.  You could try an FC7 .config file if that's 
easier.

Jesse
