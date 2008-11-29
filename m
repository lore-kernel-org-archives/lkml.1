Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbYK2GHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbYK2GHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 01:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYK2GHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 01:07:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbYK2GHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 01:07:36 -0500
Date: Fri, 28 Nov 2008 22:06:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-11-26-17-00 uploaded (hwmon / dev_attr_name)
Message-Id: <20081128220659.2d5049e6.akpm@linux-foundation.org>
In-Reply-To: <4930CCA9.9070505@oracle.com>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
	<4930CCA9.9070505@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 21:01:29 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> 
> I'm getting lots of these build errors:
> 
> drivers/hwmon/built-in.o:(.data+0x7c70): multiple definition of `dev_attr_name'

-ENOREPRODUCE.  What config?
