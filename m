Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZF0WBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZF0WBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZF0WBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 18:01:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZF0WBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 18:01:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: warning in compling
Date: Sun, 28 Jun 2009 00:01:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440906271426y2b98d36kfed43487994e0e32@mail.gmail.com>
In-Reply-To: <86802c440906271426y2b98d36kfed43487994e0e32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906280001.51332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 June 2009, Yinghai Lu wrote:
>   CC      drivers/acpi/sleep.o
> drivers/acpi/sleep.c:29: warning: ‘acpi_target_sleep_state’ defined but not used

With what .config?
