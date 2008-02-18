Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYBRNGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYBRNGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760608AbYBRNDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:03:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761335AbYBRNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:03:41 -0500
Date: Mon, 18 Feb 2008 05:01:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ext{3,4}_xattr_list() static
Message-Id: <20080218050152.bb85314f.akpm@linux-foundation.org>
In-Reply-To: <20080217081823.GK3848@cs181133002.pp.htv.fi>
References: <20080217081823.GK3848@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:18:23 +0200 Adrian Bunk <bunk@kernel.org> wrote:

>  fs/ext3/xattr.c |    4 +++-
>  fs/ext3/xattr.h |    7 -------
>  fs/ext4/xattr.c |    4 +++-
>  fs/ext4/xattr.h |    7 -------

one patch per fs, please.
