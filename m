Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYEWAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYEWAVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYEWAVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:21:15 -0400
Received: from vps1.tull.net ([66.180.172.116]:33699 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755307AbYEWAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:21:15 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 23 May 2008 10:21:01 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] debug printk infrastructure
Message-ID: <20080523002101.GC13280@tull.net>
References: <20080522211331.GA28070@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522211331.GA28070@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 05:13:31PM -0400, Jason Baron wrote:
> The debugfs file, then lists all the modules that can be 'enabled' for dynamic
> printk calls. Currently, the file has a 4 column format (excerpt from my system:

Nice work Jason.

If you write "enable all" to the debugfs file and then insmod a new
module, will debugging be enabled on the new module?

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
