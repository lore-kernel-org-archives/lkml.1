Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbYKRMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYKRMNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYKRMNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:13:10 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60966 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYKRMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:13:09 -0500
Date: Tue, 18 Nov 2008 13:13:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrey Vul <andrey.vul@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how to show ACPI key events
In-Reply-To: <e38d12ff0811171736h1238ee6at4bafe06dafff6378@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0811181312450.3104@twin.jikos.cz>
References: <e38d12ff0811171736h1238ee6at4bafe06dafff6378@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Andrey Vul wrote:

> I hacked atkbd.c to dump every keycode and enabled CONFIG_EVBUG yet
> the Fn+F{1..12} and Fn+{arrow} keys don't register an event. Is there
> a way to hack the ACPI drivers to dump keycodes?
> 
> From hacking at the Windows drivers, pressing the hotkeys generates an 
> acpi event. How do I get the acpi key events dumped?

Shouldn't just running 'acpidump' be sufficient for you?

-- 
Jiri Kosina
SUSE Labs

