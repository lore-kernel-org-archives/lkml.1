Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYJUSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYJUSoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJUSnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:43:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324AbYJUSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:43:46 -0400
Date: Tue, 21 Oct 2008 11:42:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-Id: <20081021114255.a7dabc2d.akpm@linux-foundation.org>
In-Reply-To: <20081021083822.GG15782@atrey.karlin.mff.cuni.cz>
References: <48FA3368.1040605@tremplin-utc.net>
	<20081021083822.GG15782@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 10:38:22 +0200
Pavel Machek <pavel@suse.cz> wrote:

> > Here is a submission for 2.6.28 of a driver for the ST LIS3LV02Dx
> > accelerometer, a device found in various laptops (HP in particular) and
> > embedded devices. It's the fourth iteration of what used to be called
> > MDPS. I've now made the driver very simple, hoping to make it
> > unobjectionable for acceptance :-)
> 
> Andrew, can you merge this one? It is simple enough, got some testing,
> and can't really break anything...

It had a rather obvious and rather fatal bug.

What happened to that "given enough eyeballs" thing?
