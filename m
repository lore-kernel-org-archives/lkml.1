Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYHDN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYHDN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYHDN07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:26:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60723 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753448AbYHDN05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:26:57 -0400
Date: Mon, 4 Aug 2008 14:09:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Julia Lawall <julia@diku.dk>, DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Yuen, Eric" <Eric.Yuen@lsi.com>
Subject: Re: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP
Message-ID: <20080804140932.0167ac82@lxorguk.ukuu.org.uk>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
References: <Pine.LNX.4.64.0808021715270.20095@ask.diku.dk>
	<4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 06:40:27 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Julia,
> 
> Frame_count is the major parameter used by our megaraid sas FW.  It may cause some issues after this change.  Please keep the original implementation.

The two are identical code - please explain
