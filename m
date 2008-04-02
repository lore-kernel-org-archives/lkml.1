Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbYDBUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbYDBUOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYDBUOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:14:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34961 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760028AbYDBUOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:14:07 -0400
Message-Id: <20080402201247.358430231@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 02 Apr 2008 22:12:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] vfs: add helpers to check r/o bind mounts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See first patch for description.  This is against vfs-2.6 + two
patches I posted recently.

It's not for -mm yet, as it needs conversion of unionfs (will that be
done by me, I wonder?)

Thanks,
Miklos

--
