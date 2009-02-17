Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZBQPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZBQPtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZBQPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:49:34 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50819 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBQPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:49:33 -0500
Subject: Re: [PATCH mmotm 4/6] nilfs2: use unlocked_ioctl
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ryusuke Konishi <ryusuke@osrg.net>
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090218.004341.65155545.ryusuke@osrg.net>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1234856526-1947-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1234869973.21383.1.camel@penberg-laptop>
	 <20090218.004341.65155545.ryusuke@osrg.net>
Date: Tue, 17 Feb 2009 17:49:28 +0200
Message-Id: <1234885768.11511.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 00:43 +0900, Ryusuke Konishi wrote:
> That's right, but the nilfs_ioctl_timedwait() itself was removed by
> the first patch of this patch set.  And, the compat ioctl was removed
> in the third patch.  So they don't appear in this patch.

Oh, okay. I missed rest of the series. Thanks!

