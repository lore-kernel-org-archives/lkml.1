Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYDPULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYDPULS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYDPULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:11:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbYDPULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:11:03 -0400
Date: Wed, 16 Apr 2008 13:10:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: vitalivanov@gmail.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb: remove macro code obfuscation
Message-Id: <20080416131048.debafcf3.akpm@linux-foundation.org>
In-Reply-To: <48064775.7000902@qualcomm.com>
References: <20080416104257.GA1621@elf.ucw.cz>
	<35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com>
	<20080416112909.505fe619.akpm@linux-foundation.org>
	<48064775.7000902@qualcomm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 11:37:41 -0700
Max Krasnyanskiy <maxk@qualcomm.com> wrote:

> > 
> > b) are implemented in cpp, when C is available.
> > 
> I'm not sure what you mean ? #define vs inline I suppose ?

yup.

I have a stdrant about this which I should write down permanently sometime.
