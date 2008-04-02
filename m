Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbYDBVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbYDBVlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYDBVlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:41:05 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52080 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbYDBVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:41:04 -0400
Date: Wed, 2 Apr 2008 17:22:08 -0400
Message-Id: <200804022122.m32LM8Ao014937@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] vfs: add helpers to check r/o bind mounts 
In-reply-to: Your message of "Wed, 02 Apr 2008 22:12:47 +0200."
             <20080402201247.358430231@szeredi.hu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080402201247.358430231@szeredi.hu>, Miklos Szeredi writes:
> See first patch for description.  This is against vfs-2.6 + two
> patches I posted recently.
> 
> It's not for -mm yet, as it needs conversion of unionfs (will that be
> done by me, I wonder?)

Miklos, I'll be happy to do the conversion of unionfs in -mm to use these
path_* helpers.  Is the code in these helpers going to change at all?  Can I
expect the API to remain stable?

> Thanks,
> Miklos

Thanks,
Erez.
