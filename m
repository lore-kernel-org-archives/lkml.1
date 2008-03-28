Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYC1SA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYC1SA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYC1SAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:00:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813AbYC1SAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:00:11 -0400
Date: Fri, 28 Mar 2008 10:56:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/4] Introduce pci_slot
Message-Id: <20080328105649.dd716d06.akpm@linux-foundation.org>
In-Reply-To: <20080328154139.GE17862@ldl.fc.hp.com>
References: <20080325041314.GA29666@ldl.fc.hp.com>
	<20080325041700.GD29666@ldl.fc.hp.com>
	<20080328033939.5ef5ab7b.akpm@linux-foundation.org>
	<20080328154139.GE17862@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 09:41:39 -0600 Alex Chiang <achiang@hp.com> wrote:

> In the future, do you have a better suggestion on how to do large
> sweeps on code for hardware that one might not own? Is there an
> easier way other than setting up a cross-compiler environment?

Setting up a cross-compile environment is easy -
http://userweb.kernel.org/~akpm/cross-compilers/ has several.
