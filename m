Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbXG1UEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbXG1UEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXG1UEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:04:42 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:53700 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115AbXG1UEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:04:41 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
Subject: Re: kernel panic w/ 2.6.22.1, VIA EPIA Mini ITX
Date: Sat, 28 Jul 2007 21:04:31 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200707281847.l6SIl7Sl000239@wildsau.enemy.org>
In-Reply-To: <200707281847.l6SIl7Sl000239@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707282104.31989.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have absolutely no idea what triggers this crash.

Checked the RAM on the box? Kinda weird if you're getting VRAM corruption, I 
wonder if this is due to the RAM failing at the point where the framebuffer 
is mapped?

Try running memtest86 on it.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

