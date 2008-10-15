Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYJOWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYJOWJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYJOWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:09:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbYJOWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:09:04 -0400
Date: Wed, 15 Oct 2008 15:07:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp, bart@jukie.net
Subject: Re: [PATCH 01/21] fat: document additional vfat mount options
Message-Id: <20081015150754.bfca0d4d.akpm@linux-foundation.org>
In-Reply-To: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 22:57:55 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Subject: [PATCH 01/21] fat: document additional vfat mount options

It's awkward receiving a 21-patch series late in the merge window. 
It's really really really late to be considering this sort of thing for
2.6.28.

Could I suggest that you run a quilt or a git tree for fatfs and get
that fed into linux-next?

Thanks.
