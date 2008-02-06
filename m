Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbYBFMat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbYBFMat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762151AbYBFMaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:30:39 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58920 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763022AbYBFMaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:30:16 -0500
Date: Wed, 6 Feb 2008 13:30:12 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080206133012.0a5df53e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47A856AF.5010202@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	<47A09723.7020000@gandalf.sssup.it>
	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	<47A12A2E.5040309@gandalf.sssup.it>
	<20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	<47A76106.3000103@gandalf.sssup.it>
	<20080204212523.07a6da9e@siona>
	<47A856AF.5010202@gandalf.sssup.it>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 13:29:35 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> Just one question:
> Receiving with hardware handshake works without PDC?

I don't know...I haven't tried. These patches shouldn't change anything
though.

Haavard
