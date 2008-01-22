Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYAVS7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYAVS7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYAVS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:59:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbYAVS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:59:21 -0500
Date: Tue, 22 Jan 2008 10:59:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Message-Id: <20080122105900.c7ea1cc3.akpm@linux-foundation.org>
In-Reply-To: <80873.59233.qm@web36713.mail.mud.yahoo.com>
References: <20080110010049.695da076.akpm@linux-foundation.org>
	<80873.59233.qm@web36713.mail.mud.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 08:12:08 -0800 (PST) Alex Dubov <oakad@yahoo.com> wrote:
> 
> --- Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed,  2 Jan 2008 17:42:24 +1100 oakad@exemail.com.au wrote:
> > 
> > > From: Alex Dubov <oakad@yahoo.com>
> > > 
> > > Sony MemoryStick cards are used in many products manufactured by Sony. They
> > > are available both as storage and as IO expansion cards. Currently, only
> > > MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> > > interface.
> > > 
> > 
> > Will you be running a git tree for this?  If so, please send me the link.
> > 
> 
> I rectified several additional issues with the driver. I hope you can pull the changes from here:
> 
> http://58.96.64.63/~oakad/git/.git memstick
> 

Would prefer an emailed, changelogged diff against the previous version, please.
