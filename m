Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXHSMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXHSMwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXHSMwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:52:07 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:36806 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXHSMwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:52:05 -0400
Date: Sun, 19 Aug 2007 14:51:36 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Avi Kivity <avi@qumranet.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:379
 smp_call_function_single()
Message-ID: <20070819145136.5d9f0adb@localhost>
In-Reply-To: <46C82191.90300@qumranet.com>
References: <20070810134140.2806b587@localhost>
	<6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com>
	<20070813134237.23f4b5a1@localhost>
	<46C05017.3050806@qumranet.com>
	<46C82191.90300@qumranet.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 13:55:13 +0300
Avi Kivity <avi@qumranet.com> wrote:

> Sorry about the delay -- here is the fairly simple patch.  A Tested-by: 
> would be appreciated.

it works :)

Tested-by: Paolo Ornati <ornati@fastwebnet.it>

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
