Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYCLAF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYCLAF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYCLAFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:05:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYCLAFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:05:15 -0400
Date: Tue, 11 Mar 2008 17:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Keys get stuck
Message-Id: <20080311170444.5792e902.akpm@linux-foundation.org>
In-Reply-To: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-input)

On Wed, 12 Mar 2008 00:32:14 +0100 "Fred ." <eldmannen@gmail.com> wrote:

> I (and many others) have a problem.
> 
> I am using Ubuntu 8.04 "Hardy Heron" (alpha).
> xorg  1:7.3+10ubuntu6
> Linux ubuntu 2.6.24-12-generic #1 SMP Mon Mar 10 15:32:00 UTC 2008
> i686 GNU/Linux
> 
> MSI P35 Neo motherboard with a HP USB keyboard.
> 
> Sometimes the keys get "stuck" and it keeps on repeating the button
> all the time.
> It often happen when I play games, that it repeats one of the arrow keys.
> 
> Now this is a problem that lots of people have experienced.
> I've experienced it with other kernels too.
> 
> https://bugs.launchpad.net/ubuntu/+source/xorg/+bug/194214
> 
> It is a very annoying bug, that happens to many users.
> Restarting Xorg solves the problem.
> 
> Someone said this was a problem with dynticks, but I don't know.
> 
> Does anyone know what is causing this problem, and how to fix it?
> 

