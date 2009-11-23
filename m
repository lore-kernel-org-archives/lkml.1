Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZKWVkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZKWVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZKWVkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:40:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbZKWVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:40:02 -0500
Date: Mon, 23 Nov 2009 13:40:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
Message-Id: <20091123134002.bac1e664.akpm@linux-foundation.org>
In-Reply-To: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 19:11:49 -0200
Otavio Salvador <otavio@ossystems.com.br> wrote:

> 
> I got this machine working booting it with "irqpoll" parameter however
> it drops the performance a lot and I'd like to try to fix the root
> problem of it.
> 
> Without 'irqpoll' the disk and network adaptor doesn't work.
> 
> ...
>
> [    0.000000] ACPI Error: A valid RSDP was not found (20090903/tbxfroot-219)

No ACPI.

Please raise a report against acpi_bios@kernel-bugs.osdl.org at
bugzilla.kernel.org, thanks.

