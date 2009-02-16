Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZBPXzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZBPXzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbZBPXvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:51:20 -0500
Received: from gw.goop.org ([64.81.55.164]:37133 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbZBPXvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:51:19 -0500
Message-ID: <4999FBF4.4050107@goop.org>
Date: Mon, 16 Feb 2009 15:51:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Junio C Hamano <gitster@pobox.com>, L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
References: <1234451714.10603.22.camel@laptop>
In-Reply-To: <1234451714.10603.22.camel@laptop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Hi,
>
> could we change the default of git-send-email to --no-chain-reply-to?
> These incredibly deep mail threads are a nuisance.
>   

And while we're on the **SUBJECT HERE** of git-send-email, would it be 
possible to make it refuse to send when there's placeholders in the file?

    J
