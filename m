Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbXKGRmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbXKGRmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbXKGRlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:41:51 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57394 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758011AbXKGRlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:41:50 -0500
Date: Wed, 7 Nov 2007 19:41:56 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: oprofile-list@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] AVR32: Oprofile support
Message-ID: <20071107194156.42f5bec7@siona>
In-Reply-To: <20071107155543.GE2916@zaniah>
References: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com>
	<20071107155543.GE2916@zaniah>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 16:55:43 +0100
Philippe Elie <phil.el@wanadoo.fr> wrote:

> On Wed, 07 Nov 2007 at 15:05 +0000, Haavard Skinnemoen wrote:
> 
> > This adds the necessary architecture code to run oprofile on AVR32
> > using the performance counters documented by the AVR32 Architecture
> > Manual.
> 
> Did you post the user space change to
> oprofile-list@lists.sourceforge.net ?

Yes, but not at the same time. The user space changes were posted a
couple of hours later, and only to that list.

Håvard
