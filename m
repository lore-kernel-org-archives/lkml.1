Return-Path: <linux-kernel-owner+w=401wt.eu-S936599AbXFGUcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936599AbXFGUcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbXFGUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:31:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759797AbXFGUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:31:53 -0400
Date: Thu, 7 Jun 2007 13:31:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jfannin@gmail.com (Joseph Fannin)
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net,
       Doug Thompson <norsk5@yahoo.com>
Subject: Re: 2.6.22-rc4-mm2
Message-Id: <20070607133139.30415bd2.akpm@linux-foundation.org>
In-Reply-To: <20070607193751.GA8204@nineveh.local>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070607193751.GA8204@nineveh.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 15:37:51 -0400
jfannin@gmail.com (Joseph Fannin) wrote:

> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
>     I don't think this was intentional: 
> 
>     [   29.873254] edac_stub: module license 'unspecified' taints kernel.
> 

No, I'm sure it wasn't.

Doug, please check all that code and add suitable MODULE_LICENSEs?

