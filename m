Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYCUTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYCUTdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbYCUTdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:33:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47956 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234AbYCUTda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:33:30 -0400
Date: Fri, 21 Mar 2008 13:33:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 15/16] PCI slot: Trivial cleanups for slot.c (Not for mainline!)
Message-ID: <20080321193329.GM424@parisc-linux.org>
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E3390A.7030308@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3390A.7030308@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 01:26:50PM +0900, Kenji Kaneshige wrote:
> Some trivial cleanups for drivers/pci/slot.c.

ACK

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
