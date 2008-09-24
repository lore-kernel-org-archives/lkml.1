Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYIXQg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYIXQg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYIXQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:36:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:58854 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752181AbYIXQgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:36:20 -0400
Date: Wed, 24 Sep 2008 18:37:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Airlie <airlied@gmail.com>
cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
Message-ID: <alpine.LNX.1.10.0809241836180.4671@pegasus.suse.cz>
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>  <20080924.003638.71148740.davem@davemloft.net>  <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>  <20080924.020116.193720569.davem@davemloft.net>
 <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com> <alpine.LNX.1.10.0809241829500.4671@pegasus.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Jiri Kosina wrote:

> Dave (Airlie, too many Daves on CC here really), do you by any chance 
> see any recent change in kernel intel graphic parts of DRM be causing 
> this breakage?

BTW, why is the PAT fix implented in commit 242e3df80 needed only for 
radeons?

-- 
Jiri Kosina
SUSE Labs
