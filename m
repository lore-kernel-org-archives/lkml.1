Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYECXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYECXGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYECXF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:05:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56063 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYECXF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:05:58 -0400
Date: Sun, 4 May 2008 01:05:51 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: =?UTF-8?Q?Malte_Schr=C3=B6der?= <maltesch@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
In-Reply-To: <20080504005209.13af2b2c@highlander.home.lan>
Message-ID: <alpine.DEB.1.10.0805040104100.5391@sheep.housecafe.de>
References: <20080504005209.13af2b2c@highlander.home.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX18XwOg71c232j7MNUDfBGSffRfZs+c5nW3+7X0
 +F/TJBx8hmwfLTgpxoH0Ni24I2VO09kOuDxPh5rHggksnP5h/X
 +L95aixg/aRGQDqE/b3sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Malte Schröder wrote:
> This incident happened only a few hours after booting the new kernel,
> SysRq-keys didn't work. 2.6.24.5 has been running fine.

What's with the I/O errors - did they show up in 2.6.24.5? If not, what 
has changed in your .config with .25.1?

C.
-- 
BOFH excuse #202:

kernel panic: write-only-memory (/dev/wom0) capacity exceeded.
