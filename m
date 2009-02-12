Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbZBLXnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbZBLXnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZBLXml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:42:41 -0500
Received: from THUNK.ORG ([69.25.196.29]:41677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZBLXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:42:40 -0500
Date: Thu, 12 Feb 2009 16:19:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Message-ID: <20090212211935.GE6922@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chuck Ebbert <cebbert@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org> <20090211075914.GC20842@skywalker> <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck, Anesh,

Thanks for testing out the for-stable-2.6.27 branch!  

I've updated the for-stable and for-stable-2.6.27 branches against the
latest stable releases, and I've updated the two flawed backports in
the for-stable-2.6.27 branch.  Could you do a quick double-check and
make sure the fixes are as you expect, before I send a pull request to
stable@kernel.org?

						- Ted
