Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXBDNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXBDNvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXBDNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:51:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXBDNvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:51:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: hwsusp defunct
Date: Sun, 4 Feb 2007 14:52:28 +0100
User-Agent: KMail/1.9.1
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel <pavel@amd.ucw.cz>
References: <45C5DBBA.20502@gmail.com>
In-Reply-To: <45C5DBBA.20502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041452.28874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 4 February 2007 14:12, Jiri Slaby wrote:
> Hi.
> 
> When I'm trying to suspend to mem one machine, it wakes immediatly back with 
> nothing notable in dmesg:
[--snip--] 
> 
> Will PM_DEBUG or ACPI_DEBUG help somehow? Or later kernel?

Later kernel might help, some important fixes have gone in since 2.6.19,
PCI quirks-related etc.

Please try 2.6.20-rc7 and if that doesn't help, try the latest -mm.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
