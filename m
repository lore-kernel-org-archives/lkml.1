Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZFHKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZFHKxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZFHKxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:53:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:45389 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZFHKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:53:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jonathan Cervidae <jonathan.cervidae@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Removing Huawei E220 HSDPA Modem causes system to completely hang
Date: Mon, 8 Jun 2009 12:53:57 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org
References: <200906081019.59958.jonathan.cervidae@gmail.com>
In-Reply-To: <200906081019.59958.jonathan.cervidae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081253.57811.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 8. Juni 2009 11:19:59 schrieb Jonathan Cervidae:
> While at first the easy fix to this issue would be "Don't remove modem",
> sometimes it resets itself and therefore appears to disconnect and
> reconnect which causes the system crash.

Please provide the output of "lsusb -v" and "dmesg" from the time you
plug the modem in onwards. Also could run a kernel compiled with lockdep?

	Regards
		Oliver

