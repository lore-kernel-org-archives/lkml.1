Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXKUGBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXKUGBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKUGAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:00:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbXKUGAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:00:53 -0500
Date: Tue, 20 Nov 2007 22:00:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071120220046.db5c8fde.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 13:51:47 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Hi, andrew
> 
> modpost failed for me:
>   MODPOST 360 modules
> ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 

You're a victim of the hasty unexporting fad.  Which architecture?
x86_64 I guess?
