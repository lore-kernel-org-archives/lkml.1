Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYCUTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYCUTcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbYCUTcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:32:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47937 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYCUTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:32:12 -0400
Date: Fri, 21 Mar 2008 13:32:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 12/16] PCI slot: Use .default_attrs for address file (Not for mainline!)
Message-ID: <20080321193211.GK424@parisc-linux.org>
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E3375B.4020606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3375B.4020606@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 01:19:39PM +0900, Kenji Kaneshige wrote:
> Use .default_attrs for 'address' file. This can simplify the code.

Seems like a good idea to me.  I don't think default_attrs was available
when I initially did this work.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
