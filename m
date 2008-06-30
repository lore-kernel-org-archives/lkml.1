Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYF3Kbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYF3Kbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYF3KbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:31:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755173AbYF3KbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:31:22 -0400
Date: Mon, 30 Jun 2008 11:13:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/2] atmel_serial: Implement flush_buffer() hook
Message-ID: <20080630111322.14ab71fa@lxorguk.ukuu.org.uk>
In-Reply-To: <1214821461-11772-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214821461-11772-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 12:24:21 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Avoid dumping garbage to the serial port when the tty is flushed. This
> tends to happen when rebooting from a serial console.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Alan Cox <alan@redhat.com>
