Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbZABSTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbZABSTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbZABSTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:19:03 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:44877 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754746AbZABSTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:19:01 -0500
Subject: Re: [PATCH] Update of Documentation/
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, riel@nl.linux.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <495E585D.6090402@oracle.com>
References: <20090102180412.3676.27341.stgit@hermosa.site>
	 <495E585D.6090402@oracle.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 02 Jan 2009 11:18:55 -0700
Message-Id: <1230920335.3470.250.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 10:09 -0800, Randy Dunlap wrote:
> Peter W Morreale wrote:
> > This patch updates Documentation/sysctl/vm.txt and
> > Documentation/filesystems/proc.txt.   More specifically, the section on
> > /proc/sys/vm in Documentation/filesystems/proc.txt was removed and a
> > link to Documentation/sysctl/vm.txt added.
> > 
> > Most of the verbiage from proc.txt was simply moved in vm.txt, with new
> > addtional text for "swappiness" and "stat_interval".
> > 
> > This update reflects the current state of 2.6.27.
> 
> Does it also reflect the current state of the most recently released
> mainline kernel (i.e., 2.6.28)?
> 
> More importantly, it does not apply cleanly to 2.6.28 or to today's
> linux-next-20090102 kernel.  It needs to do that, please.
> 

Ack, sorry.   Will respin.

-PWM



