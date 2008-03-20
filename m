Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYCTEX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYCTEX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 00:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYCTEXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 00:23:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53276 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYCTEXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 00:23:18 -0400
Date: Wed, 19 Mar 2008 21:21:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, v4l-dvb-maintainer@linuxtv.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: Tree for March 20
Message-Id: <20080319212121.9705ca9a.randy.dunlap@oracle.com>
In-Reply-To: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 14:39:53 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

gcc doesn't like nested /* comments:

next-20080320/drivers/media/video/bt8xx/bttv-cards.c:3030:38: warning: "/*" within comment
next-20080320/drivers/media/video/bt8xx/bttv-cards.c:3032:20: warning: "/*" within comment

---
~Randy
