Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab0CMK7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:59:54 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:57336 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab0CMK7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:59:52 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc1: lockdep warning on geode subnotebook
Date: Sat, 13 Mar 2010 11:59:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
References: <20100313105109.GA9966@elf.ucw.cz>
In-Reply-To: <20100313105109.GA9966@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003131159.47768.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 13. März 2010 11:51:09 schrieb Pavel Machek:
> sysfs related? ACPI?
> 
> Switching to clocksource acpi_pm
> Switched to NOHz mode on CPU #0
> BUG: key df3f6edc not in .data!
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x448/0x500()
> Hardware name: SA Series

I get the same warning. It is not specific to that hardware.

	Regards
		Oliver
