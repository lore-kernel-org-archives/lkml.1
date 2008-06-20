Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYFTPgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYFTPgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYFTPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:36:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYFTPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:36:32 -0400
Date: Fri, 20 Jun 2008 11:34:32 -0400
From: Bill Nottingham <notting@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Message-ID: <20080620153432.GC25954@nostromo.devel.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds (torvalds@linux-foundation.org) said: 
> Or could this perhaps be an indication that it is specific to i686 some 
> way (eg a compiler issue?)

Yes. https://bugzilla.redhat.com/show_bug.cgi?id=451068

Bill
