Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZKPCnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZKPCnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZKPCna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:43:30 -0500
Received: from senator.holtmann.net ([87.106.208.187]:49313 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZKPCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:43:29 -0500
Subject: Re: [PATCH 1/1] Adding radio type FM
From: Marcel Holtmann <marcel@holtmann.org>
To: Janakiram Sistla <janakiram.sistla@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4fb5db50911151836u5b4844adrd91b56a5ebc7084d@mail.gmail.com>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
	 <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
	 <1258216474.3299.24.camel@violet>
	 <4fb5db50911140937j278584e5nf9e4d5767a44a920@mail.gmail.com>
	 <1258221909.3299.26.camel@violet>
	 <4fb5db50911151836u5b4844adrd91b56a5ebc7084d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 03:43:21 +0100
Message-ID: <1258339401.2003.3.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janakiram,

so first of all, please stop sending emails to majordomo. That is not a
real person.

> Adding changes  RFKILL type FM  and for RFKILL for FM  in core
> 
> From 4bf0ae6c90de9a766914abeb5ab5e5428089b648 Mon Sep 17 00:00:00 2001
> From: Janakiram Sistla <janakiram.sistla@gmail.com>
> Date: Mon, 16 Nov 2009 07:58:09 +0530
> Subject: [PATCH 1/1] Adding radio type FM
> 
> Adding radio type FM in RFKILL_TYPE_.FM belongs to
> same class of with both TX/RX capability.
> 
> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>

the patch itself is fine, but can we get at least one with a proper
commit message. And if you mailer is broken, then either fix it or use
git send-email.

Regards

Marcel


