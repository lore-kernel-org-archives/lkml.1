Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXJJARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXJJARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXJJARh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:17:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:21682 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJJARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:17:36 -0400
Date: Tue, 9 Oct 2007 17:16:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of
 depends
Message-Id: <20071009171635.7e9a3e0c.randy.dunlap@oracle.com>
In-Reply-To: <Xine.LNX.4.64.0710100937390.20449@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
	<Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
	<20071009162812.00e80a0c.randy.dunlap@oracle.com>
	<Xine.LNX.4.64.0710100937390.20449@us.intercode.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 09:50:49 +1000 (EST) James Morris wrote:

> On Tue, 9 Oct 2007, Randy Dunlap wrote:
> 
> > I doth protest.  Enabling the entire NET subsystem thru a hidden
> > select is awful.  Select should be used (sparingly) to enable
> > library code only.  If someone wants NET enabled, they should
> > enable it overtly, not covertly.
> 
> Ok, fair enough.
> 
> I've dropped the patch and rebased the branch.  Please pull per:

Great, thanks.

---
~Randy
