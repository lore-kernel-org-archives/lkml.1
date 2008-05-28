Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbYE1QOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbYE1QOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYE1QOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:14:09 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62008 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYE1QOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:14:09 -0400
Date: Wed, 28 May 2008 17:13:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
 of apic_write
In-Reply-To: <20080528160413.GA6910@cvg>
Message-ID: <Pine.LNX.4.55.0805281712200.29522@cliff.in.clinika.pl>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com>
 <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl> <20080528160413.GA6910@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Cyrill Gorcunov wrote:

> Could you take a look please on
> 
> http://lkml.org/lkml/2008/5/26/146
> 
> i'm investigateting what is happening (Adrian pointed on
> main reason I think) but can't understand why is that.

 Do you have a link with the patch included?

  Maciej
