Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZBBUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZBBUMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBBUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:12:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59933 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZBBUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:12:20 -0500
Date: Mon, 2 Feb 2009 21:12:19 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@bogon.housecafe.de
To: Alex <eosyop@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel] Question about 2.6.28 kernel
In-Reply-To: <1233594684.3018.12.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0902022110290.4084@bogon.housecafe.de>
References: <1233594684.3018.12.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19KBiguYzQ+3r9xDLI+WLhwGWKU+5z56J7YVpd
 6iM6rLWzwjwkYiWovuH+QD/GPKUO0K1HGqjPacj4Ok3a3nh+Kc
 BKCp4e93EwYyYM6kfZqyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Alex wrote:
> kernel 2.6.28. Based on a simple rootkit, which can be executed on the
> 2.6.23, i got an "oops.. unable to handle kernel paging request at
> 0x...", when i run it on a new kernel. Can anyone help me finding what
> protection was added to prevent writings on kernel memory ? 

You could either post the Oops in full and discuss it right here on this 
list or follow the Documentation/SecurityBugs document if this turns out
to be security related.

Christian.
-- 
BOFH excuse #67:

descramble code needed from software company
