Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbXEWCul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbXEWCul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEWCue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:50:34 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:23573 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbXEWCud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:50:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRALRIU0ZKhRO4W2dsb2JhbACHQYhGHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Emmanuel =?iso-8859-1?q?Fust=E9?= <emmanuel.fuste@laposte.net>
Subject: Re: [INPUT] i8042 not detecting AUX port
Date: Tue, 22 May 2007 22:50:33 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <JIGRJJ$5921B4BBD75CCBFCB931C58F85C25D21@laposte.net>
In-Reply-To: <JIGRJJ$5921B4BBD75CCBFCB931C58F85C25D21@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705222250.33679.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 22 May 2007 18:23, Emmanuel Fusté wrote:
> Hello,
> 
> Just to let you know that since I jumped from 2.6.16 to
> 2.6.20.7 and 2.6.21, I need the i8042.noloop option to get the
> AUX port detected.
> Without this option, the kernel silently omit the AUX port,
> only the KBD port is detected.
> 
> If Dmitry is interested by a debug log, I will recompile a
> kernel with i8042.debug support.

You do not need to recompile anymore, just boot with i8042.debug. 

> I will try first to add the patch from Roland Scheidegger
> witch is in the Linus tree.

I doubt it will help, but I'd appreciate a dmesg with debug information
from 2.6.21 or 2.6.22-rc2.

Thannk you.

-- 
Dmitry
