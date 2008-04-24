Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYDXRKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYDXRKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYDXRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:10:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42222 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYDXRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:10:44 -0400
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <200804241656.m3OGuxf5012805@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Thu, 24 Apr 2008 12:56:59 -0400)
Subject: Re: [patch 01/13] ecryptfs: add missing lock around notify_change
References: <200804241656.m3OGuxf5012805@agora.fsl.cs.sunysb.edu>
Message-Id: <E1Jp4xI-0004Wz-VC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 19:09:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is this patch part of the r/o bind mount 13-part patchset?  It seems to
> me that this could go to akpm/Linus right now (w/o waiting for r/o bind
> mount debate to conclude).

This one's already in -mm.

> Ditto for the next one: [patch 02/13] ecryptfs: clean up (un)lock_parent

Yup.  If someone doesn't pick it up, I'll send it to Andrew sometime.

Miklos
