Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZCXAD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZCXAD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZCXADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:03:18 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:47358 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZCXADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:03:17 -0400
Message-ID: <49C8226E.9010504@oracle.com>
Date: Mon, 23 Mar 2009 16:59:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, mfasheh@suse.com,
       Theodore Tso <tytso@mit.edu>
Subject: Re: Linux 2.6.28.9 (ocfs2 build errors)
References: <20090323220927.GA11563@kroah.com>
In-Reply-To: <20090323220927.GA11563@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49C82291.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I'm announcing the release of the 2.6.28.9 kernel.
> 
> It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> series are strongly encouraged to upgrade.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.28.8 and 2.6.28.9
> 
> The updated 2.6.28.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary


fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'

(affects many fs/ocfs2/ source files)



-- 
~Randy
