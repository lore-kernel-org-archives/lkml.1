Return-Path: <linux-kernel-owner+w=401wt.eu-S933192AbXAXHoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbXAXHoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXAXHoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:44:00 -0500
Received: from main.gmane.org ([80.91.229.2]:33040 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192AbXAXHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:43:59 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: [newbie] Re: Is it possible to directly call do_path_lookup() in kernel?
Date: Wed, 24 Jan 2007 07:43:33 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnere41b.e7s.olecom@flower.upol.cz>
References: <4ae3c140701231032xd6eca27td46cc1c25e150e25@mail.gmail.com> <4ae3c140701232333j4772794j6e49da2d32c0b26d@mail.gmail.com>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-01-24, Xin Zhao wrote:
> Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/485775>

Hallo.

> I just successfully called do_path_lookup() in my kernel module. I
> just removed the "fastcall" from the declaration of do_path_lookup(),
> then the problem disappeared. I don't quite understand "fastcall"
> though.

In linkage.h header near you.

> Can someone explain it?

Please use appropriate mailing list:

Kernelnewbies: Help each other learn about the Linux kernel.
Archive:       http://mail.nl.linux.org/kernelnewbies/
FAQ:           http://kernelnewbies.org/faq/

> Thanks,
> -x
>
____

