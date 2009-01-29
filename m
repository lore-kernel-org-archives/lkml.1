Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZA2Npl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZA2Npl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZA2Np0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:45:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58664 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754879AbZA2NpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:45:24 -0500
Date: Thu, 29 Jan 2009 13:45:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pazzo Da Legare <pazzodalegare@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NEWBIE: how to change serial device<->port association
Message-ID: <20090129134537.12121834@lxorguk.ukuu.org.uk>
In-Reply-To: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
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

On Thu, 29 Jan 2009 12:02:49 +0100
Pazzo Da Legare <pazzodalegare@gmail.com> wrote:

> Dear ML,
> 
> how can I instruct the kernel (if possible) to map a certain serial
> port to a specific device ttySx?

The kernel mapping defaults are from a table so you could recompile
the kernel. However applications should always let you select a serial
port.

Alan
