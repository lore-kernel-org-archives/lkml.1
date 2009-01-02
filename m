Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZABSJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZABSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZABSJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:09:50 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:60359 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757464AbZABSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:09:49 -0500
Subject: Re: [PATCH] Update of Documentation/
From: "Peter W. Morreale" <pmorreale@novell.com>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, riel@nl.linux.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20090102180412.3676.27341.stgit@hermosa.site>
References: <20090102180412.3676.27341.stgit@hermosa.site>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 02 Jan 2009 11:09:43 -0700
Message-Id: <1230919783.3470.247.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 11:04 -0700, Peter W Morreale wrote:
> This patch updates Documentation/sysctl/vm.txt and
> Documentation/filesystems/proc.txt.   More specifically, the section on
> /proc/sys/vm in Documentation/filesystems/proc.txt was removed and a
> link to Documentation/sysctl/vm.txt added.
> 
> Most of the verbiage from proc.txt was simply moved in vm.txt, with new
> addtional text for "swappiness" and "stat_interval".
> 
> This update reflects the current state of 2.6.27.
> 
> Best,
> -PWM
> ---

Crud.  Best laid plans and all that...  

I forgot to mention that this version incorporates Randy's suggestion
about omitting the potential new sysctls for pdflush. 

I will respin the pdflush patches against this patch so the
Documentation hunk will apply.

Thx,
-PWM

