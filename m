Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZELUwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZELUwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZELUw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:52:28 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:56017 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbZELUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:52:28 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/3] Char/serial: refactor ASYNC_ flags
References: <1242049860-29501-1-git-send-email-jirislaby@gmail.com>
	<20090511185727.2a5bd4cb@lxorguk.ukuu.org.uk>
	<4A089DFD.8060609@gmail.com>
Date: Tue, 12 May 2009 22:52:18 +0200
In-Reply-To: <4A089DFD.8060609@gmail.com> (Jiri Slaby's message of "Mon, 11
	May 2009 23:51:57 +0200")
Message-ID: <87y6t2niwt.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> On 05/11/2009 07:57 PM, Alan Cox wrote:
>
>> Series all applied
>
> Thanks.
>
> Ferenc, could you apply patches 1 and 2 and confirm that it fixes your
> problem?

Yes, adding these two patches to 2.6.30-rc5 fixes my problem.
Thank you very much!
-- 
Regards,
Feri.
