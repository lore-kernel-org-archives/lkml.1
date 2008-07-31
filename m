Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYGaSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYGaSzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYGaSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:55:36 -0400
Received: from mail05do.versatel.de ([89.245.129.25]:61676 "EHLO
	mail05do.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYGaSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:55:35 -0400
Message-Id: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org>
Subject: Re: [patch 0/4] [resend] Add configuration options to disable features
To: tim.bird@am.sony.com (Tim Bird)
Date: Thu, 31 Jul 2008 20:50:51 +0200 (MEST)
Cc: davem@davemloft.net (David Miller), dwmw2@infradead.org,
       torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
In-Reply-To: <4891FD95.7090700@am.sony.com>
From: Ulrich Teichert <krypton@ulrich-teichert.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>I don't know of any embedded products that ship with NTP turned
>on.

Well, I do. To be exact, I've developed parts of it. But it's numbers
are only into the thousands, so that makes it insignificant ;-)

>It's best to assume, with embedded, that we're not shipping
>ANY of the desktop or server applications you are familiar with.
>Absent those, does something break in the kernel with multicast
>support when IGMP is turned off?

I do not think of NTP as desktop or server application, but that's
probably just me,

CU,
Uli
-- 
Dipl. Inf. Ulrich Teichert|e-mail: Ulrich.Teichert@gmx.de | Listening to:
Stormweg 24               |Pale Bride (The Von Bondies), No Time (Statues),
24539 Neumuenster, Germany|Am Strand (Smoke Blow), Sacred Decay (The Estranged)
