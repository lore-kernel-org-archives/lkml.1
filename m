Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYASN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYASN4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYASN4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:56:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60621 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYASN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:56:07 -0500
Date: Sat, 19 Jan 2008 14:56:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: remove casts
In-Reply-To: <20080118104553.GB8785@elte.hu>
Message-ID: <Pine.LNX.4.64.0801191455180.27831@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr>
 <20080118104553.GB8785@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18 2008 11:45, Ingo Molnar wrote:
>* Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>> This is against x86/mm.
>
>hm, it has checkpatch failures -

All false positives.
