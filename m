Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbYBFWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbYBFWnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbYBFWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:43:11 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42517 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbYBFWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:43:09 -0500
Date: Wed, 06 Feb 2008 15:01:26 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: my config doesnt compile in your tree
In-reply-to: <20080206215304.GA13582@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802061501.26533.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802061246.43413.yinghai.lu@sun.com>
 <20080206215304.GA13582@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 01:53:04 pm Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > your latest tree. x86/master and x86/mm
> > 
> >   AS      arch/x86/kernel/entry_64.o
> > arch/x86/kernel/entry_64.S: Assembler messages:
> > arch/x86/kernel/entry_64.S:618: Error: CFI state restore without previous remember
> 
> could you try the latest (freshly updated) x86.git, does it still have 
> this problem?

could be compiled.

but one machine got panic. others are ok. will check that.

YH

