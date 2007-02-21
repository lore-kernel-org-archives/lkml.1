Return-Path: <linux-kernel-owner+w=401wt.eu-S1161231AbXBUNpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161231AbXBUNpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161233AbXBUNpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:45:10 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:33150 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161231AbXBUNpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:45:08 -0500
To: Michael Halcrow <lkml@halcrow.us>
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, devel@openvz.org
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs lower_file largefile issue
References: <871wkju8md.fsf@sw.ru> <20070221130614.GN10765@halcrow.us>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 21 Feb 2007 16:45:17 +0300
In-Reply-To: <20070221130614.GN10765@halcrow.us> (Michael Halcrow's message of "Wed, 21 Feb 2007 07:06:14 -0600")
Message-ID: <87abz7r5ea.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Halcrow <lkml@halcrow.us> writes:

> On Wed, Feb 21, 2007 at 01:07:22PM +0300, Dmitriy Monakhov wrote:
>> Where is largefile issue in ecryptfs.
>
> Thanks for your thorough work on resolving such issues. We will
> integrate your patches and testcases into the next release as soon as
> we get a chance to review and test.
BTW previously i've sent some patches for ecryptfs to lkml but forgot add
ecryptfs-devel@lists.sourceforge.net to CC:.
links to patches:
"ecryptfs lower_file handling issues" http://lkml.org/lkml/2007/2/19/147
"ecryptfs_read_super path_lookup" errh fix http://lkml.org/lkml/2007/2/19/171

>
> Mike
> .___________________________________________________________________.
>                          Michael A. Halcrow                          
>        Security Software Engineer, IBM Linux Technology Center       
> GnuPG Fingerprint: 419C 5B1E 948A FA73 A54C  20F5 DB40 8531 6DCA 8769
>
> "To prohibit sharing software is to cut the bonds of society."       
>  - Richard Stallman

