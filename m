Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYBZIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYBZIz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYBZIzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:55:19 -0500
Received: from www.tglx.de ([62.245.132.106]:53733 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYBZIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:55:18 -0500
Date: Tue, 26 Feb 2008 09:50:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
In-Reply-To: <47C34CEA.7060307@pobox.com>
Message-ID: <alpine.LFD.1.00.0802260949200.7583@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org> <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
 <47C34CEA.7060307@pobox.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Jeff Garzik wrote:

> Welcome to test this... (attached, not tested nor even compiled, really)

Works, but I agree with Ingo vs. the stand alone irq_en/disable.

Thanks,
	tglx
