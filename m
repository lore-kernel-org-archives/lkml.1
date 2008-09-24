Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYIXSJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYIXSJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIXSJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:09:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:33615 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751436AbYIXSJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:09:37 -0400
Date: Wed, 24 Sep 2008 20:10:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>
cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <alpine.LNX.1.10.0809241836180.4671@pegasus.suse.cz>
Message-ID: <alpine.LNX.1.10.0809242008550.4671@pegasus.suse.cz>
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>  <20080924.003638.71148740.davem@davemloft.net>  <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>  <20080924.020116.193720569.davem@davemloft.net>
 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com> <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz> <alpine.LNX.1.10.0809241836180.4671@pegasus.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jiri Kosina wrote:

> > Dave (Airlie, too many Daves on CC here really), do you by any chance 
> > see any recent change in kernel intel graphic parts of DRM be causing 
> > this breakage?
> BTW, why is the PAT fix implented in commit 242e3df80 needed only for 
> radeons?

Further important observation -- as far as I can see, all affected 
machines by this bug whatsoever (and the number of reportes is increasing) 
were using i915 DRM.

-- 
Jiri Kosina
SUSE Labs
