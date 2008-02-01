Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYBAWfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYBAWfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbYBAWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:35:11 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33092 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbYBAWfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:35:09 -0500
Date: Fri, 1 Feb 2008 17:34:57 -0500
Message-Id: <200802012234.m11MYvHL001108@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: unionfs_copy_attr_times oopses 
In-reply-to: Your message of "Fri, 01 Feb 2008 20:30:46 GMT."
             <Pine.LNX.4.64.0802011905230.32485@blonde.site> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0802011905230.32485@blonde.site>, Hugh Dickins writes:
> Hi Erez,
> 
> Aside from the occasional "unionfs: new lower inode mtime" messages
> on directories (which I've got into the habit of ignoring now), the
> only problem I'm still suffering with unionfs over tmpfs (not tested
> any other fs's below it recently) is oops in unionfs_copy_attr_times.
[...]

Thanks for the report and patch(es).  I'll start looking at this over the
weekend.  Could you do me a favor and open a bugzilla report
(https://bugzilla.filesystems.org/), upload your patches, etc.?  It'd be
easier for us to exchange info/patches and track the problem that way.

Thanks,
Erez.
