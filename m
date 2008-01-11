Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYAKH6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYAKH6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYAKH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:58:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:12732 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYAKH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:58:47 -0500
Message-ID: <bd5b16740801102358q3587e5cdp7a949be4d982828@mail.gmail.com>
Date: Fri, 11 Jan 2008 09:58:46 +0200
From: "Ohad Ben-Cohen" <ohad@bencohen.org>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH][FIX] Bluetooth: always send explicit hci_ll wake-up acks
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <20080110.222456.209443591.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.091a3ceefb96c3e3@bencohen.org>
	 <20080110.222456.209443591.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n 1/11/08, David Miller <davem@davemloft.net> wrote:
> From: Ohad Ben-Cohen <ohad@bencohen.org>
> Date: Mon, 7 Jan 2008 18:22:48 +0200 (IST)
>
> > In the (rare) event of simultaneous mutual wake up requests,
> > do send the chip an explicit wake-up ack. This is required
> > for Texas Instruments's BRF6350 chip.
> >
> > Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
>
> Applied, thanks.

Thanks.
