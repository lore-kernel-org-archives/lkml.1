Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbXAaBZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbXAaBZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXAaBZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:25:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbXAaBZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:25:29 -0500
Date: Tue, 30 Jan 2007 17:25:25 -0800
From: Andrew Morton <akpm@osdl.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070130172525.f32fb9ea.akpm@osdl.org>
In-Reply-To: <45BFEDFB.6000500@imap.cc>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<45BFC442.5000903@gmail.com>
	<45BFEDFB.6000500@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 02:16:43 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 30.01.2007 23:18 schrieb Maciej Rutecki:
> > Second problem, power button doesn't work. When I pressed it, I has this
> > error:
> > 
> > ACPI Error (evevent-0305): No installed handler for fixed event
> > [00000002] [20070126]
> 
> Same here, minus the message. (Or perhaps I just don't know where to look.)
> Problem also exists in 2.6.20-rc6-mm2. With 2.6.20-rc6-git1 the power
> button of this machine works fine.
> 

That's significant - in your case at least the 2.6.20-rc6-mm3 ACPI update
isn't the cause.

