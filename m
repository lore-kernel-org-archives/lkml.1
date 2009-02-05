Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZBEWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZBEWEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZBEWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:04:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:50658 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZBEWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:04:12 -0500
MIME-Version: 1.0
In-Reply-To: <86802c440902051031l78e4cb25va1b0e6274205a3a0@mail.gmail.com>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A4DFB.7040608@kernel.org>
	 <20090205181534.GC5661@elte.hu>
	 <86802c440902051031l78e4cb25va1b0e6274205a3a0@mail.gmail.com>
Date: Thu, 5 Feb 2009 14:04:10 -0800
Message-ID: <9ae48b020902051404g34b25c2cv189f0da8c947cc02@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: host mmconfig detect clean up v2
From: Ed Swierk <eswierk@aristanetworks.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 10:31 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> should go with Ed's updated patch before.
>
> to tip or pci tree.

This looks good to me, too. Thanks.

Do you want me to submit a revised patch for detecting MCP55 mmconfig?

--Ed
