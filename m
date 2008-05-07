Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbYEGMpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbYEGMpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbYEGMoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:44:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbYEGMol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:44:41 -0400
Date: Wed, 7 May 2008 14:45:20 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080507144520.17e9902a@strauss.suse.de>
In-Reply-To: <20080507114343.GB5583@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080428092513.495378af.akpm@linux-foundation.org>
	<20080429175419.6c8a0ebf@strauss.suse.de>
	<20080430133824.GC18711@boogie.lpds.sztaki.hu>
	<20080430165131.7426d5d3@strauss.suse.de>
	<20080507114343.GB5583@boogie.lpds.sztaki.hu>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gabor Gombas [2008-05-07 13:43]:
>
> I'm running it but it won't help if I'll be working on a different
> virtual desktop when the hang happens...

You can log it to a file or output it over serial console. Or make the
window sticky. ;)


	Bernhard
