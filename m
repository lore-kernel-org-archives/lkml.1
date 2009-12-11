Return-Path: <linux-kernel-owner+w=401wt.eu-S1762643AbZLKVLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762643AbZLKVLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZLKVK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:10:59 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:38772 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbZLKVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:10:58 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: linux-kernel@vger.kernel.org
Subject: Re: K8 ECC error with linux-2.6.32
Date: Fri, 11 Dec 2009 22:11:03 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.32-fglrx; KDE/4.3.80; x86_64; ; )
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912112211.04071.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 11 Dezember 2009 22:02:47 schrieb Johannes Hirte:
> With kernel 2.6.32 I get now:
> 
> Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
> Dec 11 21:26:37 datengrab kernel: K8 ECC error.
...

I forgot to mention, it's a Tyan Tiger K8W S2875 Board with AMD 8151+8111 
chipset, two Opteron 252, 3GB RAM and a Radeon 3650 (RV635) AGP card.
