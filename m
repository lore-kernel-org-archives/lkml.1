Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbYCSUfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbYCSUfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYCSTld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39927 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbYCSTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:31 -0400
Date: Tue, 18 Mar 2008 18:55:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3, v10] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080319005535.GB424@parisc-linux.org>
References: <20080318210539.GA30421@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318210539.GA30421@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 03:05:39PM -0600, Alex Chiang wrote:
> Also, v10 should fix the "pci_slot module changes the sysfs name"
> issue that Kenji-san was seeing.

I thought we agreed that the current names are wrong, and we shouldn't
consider this 'different name' an issue.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
