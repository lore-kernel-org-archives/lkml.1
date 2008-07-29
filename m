Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYG2Bt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYG2Bt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYG2Bts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:49:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42307 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYG2Bts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:49:48 -0400
Date: Mon, 28 Jul 2008 19:49:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <willy@linux.intel.com>, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 3/3] PCI: Add pci_read_base() API
Message-ID: <20080729014931.GB28989@parisc-linux.org>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx> <7A25B56E4BE99C4283EB931CD1A40E1101586F18@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E1101586F18@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 09:22:03AM +0800, Zhao, Yu wrote:
> Greetings,
> 
> It would be nice if people can have an enhanced pci_update_resource to update non-standard BARs probed by pci_read_base.

Yes, that would be a natural addition to the API.  However, we don't
tend to add APIs until we have a use case for them.  Do you have
anything in the pipeline that could use this feature?  I'm quite happy
to write the code for you if you do.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
