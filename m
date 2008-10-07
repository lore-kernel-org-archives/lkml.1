Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYJGKI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYJGKI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYJGKHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:07:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57621 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755563AbYJGKHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:07:34 -0400
Date: Tue, 7 Oct 2008 11:07:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Reg Clemens <reg@dwf.com>
Cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: Whats happening with PPS changes?
Message-ID: <20081007110726.557fa2e1@lxorguk.ukuu.org.uk>
In-Reply-To: <200810070645.m976jwoS021514@deneb.dwf.com>
References: <200810070645.m976jwoS021514@deneb.dwf.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 00:45:58 -0600
Reg Clemens <reg@dwf.com> wrote:

> Whats happening with the PPS changes that Ive seen posted here several
> times?
> 
> I don't see them in any of the 2.6.27 release candidates, nor do I see them
> in the list of Queued TTY patches for 2.6.28.

The tty bits need someone to make a decision on the main PPS code. That I
would have assumed was Ingo but he's not spoken up since some comments on
the first draft.

Alan
