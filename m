Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbXD1RH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbXD1RH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXD1RH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:07:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbXD1RHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:07:25 -0400
Date: Sat, 28 Apr 2007 13:06:44 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428170644.GB20646@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070427221803.2a117c23.akpm@linux-foundation.org> <p73tzv022qw.fsf@bingen.suse.de> <20070428030213.4787031f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428030213.4787031f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 03:02:13AM -0700, Andrew Morton wrote:

 > This little checking tool should have both "error" and "warning" levels -
 > AKA "fix this" and "think about this" levels.  BUG_ON would be a warning
 > thing.

There's a -pedantic option there just for this.  I'll move BUG_ON under it.
What's the consensus on the u32 thing, move that too, or drop completely?

	Dave

-- 
http://www.codemonkey.org.uk
