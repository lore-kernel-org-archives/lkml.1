Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbZDBVSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbZDBVSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZDBVR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:17:58 -0400
Received: from matrixpower.ru ([195.178.208.66]:34777 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZDBVR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:17:57 -0400
Date: Fri, 3 Apr 2009 01:17:54 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] Staging: pohmelfs: should include fs_struct.h
Message-ID: <20090402211754.GA7479@ioremap.net>
References: <a4423d670904020437q446f7c62xa209822f10573c28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904020437q446f7c62xa209822f10573c28@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander.

On Thu, Apr 02, 2009 at 03:37:10PM +0400, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> drivers/staging/pohmelfs/path_entry.c: In function
> 'pohmelfs_construct_path_string':
> drivers/staging/pohmelfs/path_entry.c:48: error: dereferencing pointer
> to incomplete type
> drivers/staging/pohmelfs/path_entry.c:49: error: dereferencing pointer
> to incomplete type
> drivers/staging/pohmelfs/path_entry.c:50: error: dereferencing pointer
> to incomplete type
> drivers/staging/pohmelfs/path_entry.c: In function 'pohmelfs_path_length':
> drivers/staging/pohmelfs/path_entry.c:95: error: dereferencing pointer
> to incomplete type
> drivers/staging/pohmelfs/path_entry.c:96: error: dereferencing pointer
> to incomplete type
> drivers/staging/pohmelfs/path_entry.c:97: error: dereferencing pointer
> to incomplete type
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Looks good. Ack.
Greg please queue it for inclusion.

-- 
	Evgeniy Polyakov
