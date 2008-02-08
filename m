Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbYBHApl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbYBHApl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYBHApc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:45:32 -0500
Received: from relay2.sgi.com ([192.48.171.30]:37218 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752581AbYBHApb (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:45:31 -0500
Date: Fri, 8 Feb 2008 11:44:30 +1100
From: David Chinner <dgc@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/45] 2.6.24-stable review
Message-ID: <20080208004430.GE155407@sgi.com>
References: <20080207204549.GA16389@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Is there any reason why the XFS patch I sent to the stable list a
couple of days ago is not included in this series?

http://oss.sgi.com/archives/xfs/2008-02/msg00027.html

We've had multiple reports of it, and multiple confirmations that
the patch in the link above fixes the problem.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
