Return-Path: <linux-kernel-owner+w=401wt.eu-S932613AbZHUUdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbZHUUdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbZHUUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:33:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbZHUUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:33:40 -0400
Message-ID: <4A8F0481.7050003@zytor.com>
Date: Fri, 21 Aug 2009 13:33:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Kelly Bowa <kelly.bowa@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Atom processor inclusion
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu> <200908201433.54785.tobias.doerffel@gmail.com> <4A8EE544.6020002@zytor.com> <4A8EE606.7000807@linux.intel.com> <20090821193841.GA5356@elte.hu>
In-Reply-To: <20090821193841.GA5356@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 12:38 PM, Ingo Molnar wrote:
> 
> makes sense.
> 

OK, but I think that's a separate project.  For now, I'll put the patch
as-is into tip:x86/cpu.

	-hpa

