Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0CIToX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:44:23 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:34182 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0CIToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:44:20 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 14:44:20 EST
Subject: Re: [PATCH] sysfs: Fixup broken chown tracking
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <20100309191127.GA30462@obsidianresearch.com>
References: <20100309191127.GA30462@obsidianresearch.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 09 Mar 2010 14:36:12 -0500
Message-Id: <1268163372.29493.1965.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like your patch is already in the tree as commit
7c0ff870d1ed287504a61ed865f3d728c757436b. We saw this problem before and
Eric fixed it up. I thought it was very odd that you posted this 5
minutes ago and it was already upstream.

Dave

