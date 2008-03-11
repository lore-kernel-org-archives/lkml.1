Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYCKCMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYCKCMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYCKCMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:12:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYCKCMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:12:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/6] signals: handle_stop_signal: don't worry about SIGKILL
In-Reply-To: Oleg Nesterov's message of  Sunday, 9 March 2008 20:23:29 +0300 <20080309172329.GA1344@tv-sign.ru>
References: <20080309172329.GA1344@tv-sign.ru>
X-Shopping-List: (1) Generic log lips
   (2) Perspicacious diaphanous suspicions
   (3) Stagnant aspersion tampons
Message-Id: <20080311021136.0F86E26F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 19:11:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This look OK to me too.  I'm not 100% sure we didn't overlook some subtlety.
But I think your analysis is sound.


Thanks,
Roland
