Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYAHLji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYAHLji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760146AbYAHLiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:38:10 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51598 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135AbYAHLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:38:08 -0500
Message-Id: <20080108113502.184459371@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 08 Jan 2008 12:35:02 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: [patch 0/9] mount ownership and unprivileged mount syscall (v6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After much sitting in -mm, Andrew dropped this patchset due to
conflicts with other stuff.  It would be nice, if it could be reviewed
in time for 2.6.26 (2.6.25 is closed as far as I understand).

v5 -> v6:

 - update to latest -mm
 - preliminary util-linux-ng support (will post right after this series)

Thanks,
Miklos

--
