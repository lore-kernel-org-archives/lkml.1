Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021Ab0ASBUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0ASBUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839Ab0ASBUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:20:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38061 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688Ab0ASBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:20:33 -0500
Date: Tue, 19 Jan 2010 01:23:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Mark Allyn <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, charles.f.johnson@intel.com
Subject: Re: [PATCH] Rename rar_driver to rar_register
Message-ID: <20100119012307.6b40d2db@lxorguk.ukuu.org.uk>
In-Reply-To: <20100119001243.GD27551@kroah.com>
References: <1263849696-23060-1-git-send-email-mark.a.allyn@intel.com>
	<20100119001243.GD27551@kroah.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 16:12:43 -0800
Greg KH <greg@kroah.com> wrote:

> On Mon, Jan 18, 2010 at 01:21:36PM -0800, Mark Allyn wrote:
> > The purpose of this patch is to change the name of rar_register source
> > files (both the .c and .h files) to rar_register.
> > 
> > This is the first of seven patches for the rar_register driver
> > for Sunday, January 17, 2009
> > 
> > This is to clarify that this driver is for the rar_register.
> 
> What does that mean?  Why does the name matter?

RAR are the registers. The code handles the registers. There are things
that use the registers which are drivers but are not this code. It could
almost be "librar" except it's not quite used as a library
