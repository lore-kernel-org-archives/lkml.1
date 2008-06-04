Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbYFDORc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbYFDORc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYFDORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:17:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46966 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753851AbYFDORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:17:15 -0400
Date: Wed, 4 Jun 2008 15:01:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Strip stray space in log message
Message-ID: <20080604150158.17a33e69@core>
In-Reply-To: <200806041538.53326.jdelvare@suse.de>
References: <200806041538.53326.jdelvare@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 15:38:53 +0200
Jean Delvare <jdelvare@suse.de> wrote:

> Strip a stray space in log messages of 3 watchdog drivers.
> (And fold these long lines to make checkpatch.pl happy.)

Don't break up strings of quoted text - it makes grepping for them much
harder.

Alan
