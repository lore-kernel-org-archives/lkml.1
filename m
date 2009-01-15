Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbZAOAJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbZAOAJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZAOAJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:09:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756143AbZAOAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:09:36 -0500
Date: Wed, 14 Jan 2009 16:09:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bryan Donlan" <bdonlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: OOPS and freeze on 2.6.29-rc1 on xen-x86
Message-Id: <20090114160932.74c68a4d.akpm@linux-foundation.org>
In-Reply-To: <3e8340490901112247y4d82a71ah23ab1453ca0d9819@mail.gmail.com>
References: <3e8340490901112247y4d82a71ah23ab1453ca0d9819@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009 01:47:40 -0500
"Bryan Donlan" <bdonlan@gmail.com> wrote:

> After testing 2.6.29-rc1 on xen-x86 with a btrfs root filesystem, I
> got the OOPS quoted below and a hard freeze shortly after boot
> (running update-grub of all things).
> Boot messages and config are attached.
> 
> This is on a test system, so I'd be happy to test any patches.

Are you able to reproduce this without using btrfs?
