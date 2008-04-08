Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYDHPNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYDHPNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYDHPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:13:13 -0400
Received: from mail.vyatta.com ([216.93.170.194]:33830 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYDHPNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:13:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.259
Date: Tue, 8 Apr 2008 10:13:07 -0500
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Message-ID: <20080408101307.7b3717ed@speedy>
In-Reply-To: <200804011107.38563.inaky@linux.intel.com>
References: <200804011107.38563.inaky@linux.intel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that there is a binary supplicant required. After the experience with the
ipw3945 driver lack of acceptance, I would hope that Intel would have learned
that dependence on binary userspace components would limit acceptance especially
with other more hostile projects (OpenBSD).
