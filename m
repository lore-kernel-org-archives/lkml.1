Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYKVAAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYKVAAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYKVAAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:00:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbYKVAAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:00:44 -0500
Date: Fri, 21 Nov 2008 16:00:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, Eric.Piel@tremplin-utc.net, trenn@suse.de,
       rpurdie@rpsys.net, hmh@hmh.eng.br
Subject: Re: HP accelerometer: split chip handling from HP ACPI interface
Message-Id: <20081121160022.86020953.akpm@linux-foundation.org>
In-Reply-To: <20081121212121.GA7222@elf.ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 22:21:21 +0100
Pavel Machek <pavel@suse.cz> wrote:

> This patch splits handling between chip-specific lis3lv02d and HP/ACPI
> specific hp_accel.c.

umm, so?  What reason does anyone have for applying it?
