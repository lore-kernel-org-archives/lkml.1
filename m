Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZIJU1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZIJU1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZIJU1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:27:00 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:14837 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZIJU07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:26:59 -0400
Date: Thu, 10 Sep 2009 13:27:02 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, jmorris@namei.org,
       len.brown@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
Subject: Re: [PATCH] tpm_tis: TPM_STS_DATA_EXPECT workaround
Message-ID: <20090910202702.GS12922@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com> <1246410255-6839-6-git-send-email-adi@vmware.com> <20090701110136.576a1d14@lxorguk.ukuu.org.uk> <1246455920.9140.28.camel@blackbox> <20090720182732.GL6370@hexapodia.org> <1252609714.4837.87.camel@blackbox> <1252612471.4837.107.camel@blackbox> <1252612709.30578.219.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252612709.30578.219.camel@desktop>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 12:58:29PM -0700, Daniel Walker wrote:
> > +static int itpm = 0;
> 
> This patch has some checkpatch issues .. Could you run it
> through ./script/checkpatch.pl and fix the issues that get reported?

Thanks for the reminder, will do.

-andy
