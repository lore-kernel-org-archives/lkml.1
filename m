Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZAEWSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZAEWSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZAEWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:18:31 -0500
Received: from mail.lang.hm ([64.81.33.126]:40808 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbZAEWSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:18:30 -0500
Date: Mon, 5 Jan 2009 15:20:35 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <86802c440901051407ib7e69fey527dcce77cd2a461@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901051520210.27641@asgard.lang.hm>
References: <20090102174845.GD5372@localhost>  <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>  <20090103161052.GB11093@localhost>  <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>  <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>
  <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>  <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>  <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com> <86802c440901051407ib7e69fey527dcce77cd2a461@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Yinghai Lu wrote:

> can you make sure X86_64_APCI_NUMA is set?
>
> # CONFIG_X86_64_ACPI_NUMA is not set

will do, recompiling...

David Lang
