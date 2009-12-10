Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbZLJWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbZLJWDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761825AbZLJWDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:03:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761822AbZLJWDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:03:51 -0500
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: phoronix test,  openssl bad performance
From: Andi Kleen <andi@firstfloor.org>
References: <4B213ADD.6010200@gmail.com>
Date: Thu, 10 Dec 2009 23:03:52 +0100
In-Reply-To: <4B213ADD.6010200@gmail.com> (Xose Vazquez Perez's message of "Thu, 10 Dec 2009 19:15:57 +0100")
Message-ID: <877hsumqpj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

> hi,
>
> In the openssl test, Solaris is 2.4X times faster than Linux.
>
> The hardware was:
> ThinkPad T61 with Intel Core 2 Duo T9300 + 2GB RAM
>
> OS (all 32-bit):
> Build 127 of OpenSolaris 2010.02 with 5.11 kernel + GCC 4.3.2
> Fedora 12 Linux 2.6.31 kernel + GCC 4.4.2
> Ubuntu 9.10 Linux 2.6.31 kernel + GCC 4.4.1

You should probably report that to Fedora through their bugzilla, 
it's unlikely to be a linux kernel problem.

-Andi
