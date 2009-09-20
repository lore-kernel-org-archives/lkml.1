Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbZITVMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbZITVMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbZITVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:12:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35488 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZITVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:12:32 -0400
Date: Sun, 20 Sep 2009 23:12:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH] mn10300 linker script cleanup
Message-ID: <20090920211234.GA27042@merkur.ravnborg.org>
References: <alpine.DEB.1.10.0909201414380.3101@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909201414380.3101@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 02:28:03PM -0400, Tim Abbott wrote:
> David,
> 
> I noticed that you already converted to mn10300 architecture to use some 
> of the new macros in vmlinux.lds.h.  It seems to me that one could clean 
> things up further by using some of the higher-level macros 
> (RW_DATA_SECTION, INIT_TEXT_SECTION, INIT_DATA_SECTION).  Patch below.
> 
> 	Best regards,
> 	-Tim Abbott
> 
> mn10300: Clean up linker script using higher-level macros.

Or maybe David used an older version as his base.
Patch looks good.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
