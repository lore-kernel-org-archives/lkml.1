Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZKDQeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZKDQeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZKDQeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:34:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38424 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756099AbZKDQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:34:13 -0500
Date: Wed, 4 Nov 2009 16:35:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, balbir@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       Jan Safranek <jsafrane@redhat.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104163508.17b961f0@lxorguk.ukuu.org.uk>
In-Reply-To: <20091104161142.GA8825@us.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
	<20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
	<20091104081618.GD3560@balbir.in.ibm.com>
	<1257348117.31972.4360.camel@nimitz>
	<20091104161142.GA8825@us.ibm.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you do, then while I DETEST the extra typing, I think
> /sys/kernel/cgroup makes most sense, since that's where you find
> debugfs and securityfs.

And for everyone else

man ln

We have the technology ...

Alan
