Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYEMVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYEMVVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbYEMVVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:21:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49652 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYEMVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:21:40 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080513211756.GA25349@fieldses.org> (bfields@fieldses.org)
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
References: <20080509124107.645600519@szeredi.hu> <20080509155040.GB798@fieldses.org> <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu> <20080509164044.GA1907@fieldses.org> <E1Jw1ge-0002eZ-Hk@pomaz-ex.szeredi.hu> <20080513211756.GA25349@fieldses.org>
Message-Id: <E1Jw1w8-0002hW-Sj@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 May 2008 23:21:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, it was in the nfs-2.6 tree after all (commit 4d7c402).  I just
> 
> I think you must mean c4d7c402b788b73dc24f1e54a57f89d3dc5eb7bc, "NFS:
> Remove the buggy lock-if-signalled case from do_setlk()"?

Yeah.

Miklos
