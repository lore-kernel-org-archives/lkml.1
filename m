Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbZD3AMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbZD3AMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZD3AM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:12:27 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:37973 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZD3AM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:12:26 -0400
Date: Thu, 30 Apr 2009 02:12:14 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Fix bogus modpost warnings
Message-ID: <20090430001214.GA22242@linux-mips.org>
References: <20090429123211.GA12874@linux-mips.org> <20090429204846.GA655@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429204846.GA655@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:48:46PM +0200, Sam Ravnborg wrote:

> > this addition check there are still section names left for which the if
> > condition would ever be true.  Data sections maybe?
> 
> Anders Kaseorg already wrote a better patch to fix this - appended below.
> Could you please give it a try and let me know it it
> works for you too.

Works as advertised for me:

Tested-by: Ralf Baechle <ralf@linux-mips.org>

> It is about to be applied to kbuild-next - I have just been sidetracked
> by other stuff.

kbuild-next sounds like 2.6.31 stuff - I hope this will still go into
2.6.30?

Thanks,

  Ralf
