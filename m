Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZG1JjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZG1JjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZG1JjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:39:08 -0400
Received: from leia.mcbone.net ([194.97.104.42]:42436 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZG1JjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:39:07 -0400
Subject: Re: early_ioremap messages with old ASUS board
From: Jens Rosenboom <jens@mcbone.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <86802c440907230739ufe30b4cocc4b16faacc009c4@mail.gmail.com>
References: <1248351634.7237.32.camel@fnki-nb00130>
	 <86802c440907230739ufe30b4cocc4b16faacc009c4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 11:36:48 +0200
Message-Id: <1248773808.6757.4.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 07:39 -0700, Yinghai Lu wrote:
> please try attached ...

No more leak messages when booting with this patch.

