Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYGIWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYGIWA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYGIWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:00:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYGIWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:00:48 -0400
Date: Wed, 9 Jul 2008 14:54:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the epca driver to permit epca_setup() to be
 invoked from the kernel cmdline
Message-Id: <20080709145458.0ccde09d.akpm@linux-foundation.org>
In-Reply-To: <20080709153906.41711e65@the-village.bc.nu>
References: <20080709131927.639.72528.stgit@warthog.procyon.org.uk>
	<20080709153906.41711e65@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 15:39:06 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Will add to the ttydev tree.

What is the scope/mandate of that tree?


coz I'm wondering about

remove-is_tty.patch

pty-remove-unused-unix98_pty_count-options.patch

proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
nwflash-use-simple_read_from_buffer.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch

