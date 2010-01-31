Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480Ab0AaPxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0AaPxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 10:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200Ab0AaPxV
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 10:53:21 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:53969 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0AaPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 10:53:20 -0500
Message-ID: <4B65A76D.3080508@mandriva.org>
Date: Sun, 31 Jan 2010 17:53:17 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at fs/dcache.c:670!
References: <5d75f4611001310715o55674116n436e13e3a5437fc4@mail.gmail.com>
In-Reply-To: <5d75f4611001310715o55674116n436e13e3a5437fc4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.01.2010 17:15, BuraphaLinux Server skrev:
> Hello list,
>
> Is this really a kernel problem, or did I do something stupid?  This
> is an x86_64 kernel but a 32bit userland.
>

you need the patch referenced here:

http://lkml.org/lkml/2010/1/28/292

--
Thomas
