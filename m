Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbYA2ST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbYA2ST3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbYA2SSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:18:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39864 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760382AbYA2SSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:18:38 -0500
Message-Id: <20080129181750.616092886@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 29 Jan 2008 19:17:50 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 0/3] fuse: update for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's one small fix, one cleanup and one in preparation for writable
mmap support (but which makes sense on it's own as well).

Please apply.

Thanks,
Miklos

--
