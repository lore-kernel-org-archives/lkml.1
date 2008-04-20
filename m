Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYDTRXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYDTRXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYDTRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:23:04 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3622 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYDTRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:23:03 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT pull] (hr)timer updates feed from Andrew
Date: Sun, 20 Apr 2008 19:22:43 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0804192247580.3261@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804192247580.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201922.46749.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 19. April 2008, Thomas Gleixner wrote:

> John Stultz (1):
>       time: close small window for vsyscall time inconsistencies

Out of curiosity: why did you merge this patch despite my objections?
Why couldn't you wait a little while longer? You knew I was waiting for more 
information to analyze this properly...
(Especially as it turns out that this patch doesn't really close the window, 
it only makes it smaller.)

bye, Roman
