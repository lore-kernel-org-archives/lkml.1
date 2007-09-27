Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbXI0PSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbXI0PSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbXI0PRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:17:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51933 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbXI0PRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:17:45 -0400
Date: Thu, 27 Sep 2007 17:17:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: Floating Point Issue
In-Reply-To: <109515.18343.qm@web7805.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709271717180.30621@fbirervta.pbzchgretzou.qr>
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27 2007 12:41, mahamuni ashish wrote:
>I have small code....

This is not a kernel problem. (Read your C book and/or ask in
a C newsgroup.)

>char ch[4];
>memset(ch,'\0',strlen(ch) );
