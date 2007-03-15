Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbXCOUpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbXCOUpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXCOUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:45:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48219 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbXCOUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:45:11 -0400
Date: Thu, 15 Mar 2007 13:44:28 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315204428.GF21942@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <20070315041329.GB21942@ca-server1.us.oracle.com> <1173989199.6506.109.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173989199.6506.109.camel@heimdal.trondhjem.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 04:06:39PM -0400, Trond Myklebust wrote:
> Hell no! Struct file carries information that is essential for those of
> us that use strong authentication. It stays.

Joel pointed this out yesterday for the nfs case. Not to worry, we'll keep
struct file around :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
