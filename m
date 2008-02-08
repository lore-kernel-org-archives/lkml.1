Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYBHNoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYBHNoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:44:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYBHNoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:44:37 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:60532 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYBHNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:44:36 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 08:44:36 EST
To: "rohit h" <hrohit85@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: C++ in linux kernel
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Feb 2008 14:39:45 +0100
In-Reply-To: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
Message-ID: <8763wz36u6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2008 13:33:24.0861 (UTC) FILETIME=[2E200AD0:01C86A57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"rohit h" <hrohit85@gmail.com> writes:

> Hi,
>  I am a kernel newbie.
>  I tried to insmod a C++ module containing classes, inheritance.
>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
>  What could the problem be?

If you want to use C++ in the kernel you would need to provide
all the run time library support for it youself. It's possible,
but not easy and encouraged

-Andi
