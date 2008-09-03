Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYICJMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYICJMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYICJMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:12:35 -0400
Received: from mailer1.option.com ([81.246.70.162]:50592 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYICJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:12:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgBAITxvUgKAAAZ/2dsb2JhbAAItXKBaQ
Message-ID: <48BE4BA0.3060908@option.com>
Date: Wed, 03 Sep 2008 10:32:32 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Filip Aben <f.aben@option.com>,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jeff Garzik <jgarzik@pobox.com>
Subject: re /drivers/char/n_tty.c drops characters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 09:12:33.0226 (UTC) FILETIME=[32F212A0:01C90DA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
There are functions tty_throttle & tty_unthrottle
called from the n_tty line discipline, it might do everything
I want it to do.

I might be plain wrong & casting asparagus about my understanding of
the n_tty & it might not drop packets
in the latest kernel.

If I'm wrong about n_tty.c & being stupid thinking the n_tty layer 
drops packets please inform me & tell me why it doesn't.

Is whats in n_tty bulletproof if used properly.
-- 
best regards,
D.J. Barrow
