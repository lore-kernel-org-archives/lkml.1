Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZFBEgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZFBEgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZFBEgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:36:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49502 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZFBEgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:36:23 -0400
Message-Id: <200906020436.n524aIkk041191@www262.sakura.ne.jp>
Subject: Re: [PATCH 1/5] Move sleeping operations to outside the semaphore.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 13:36:18 +0900
References: <200906020141.n521faqb003256@www262.sakura.ne.jp> <20090602040538.GA21698@hallyn.com>
In-Reply-To: <20090602040538.GA21698@hallyn.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 02062009 #2073305, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> another thing making these patches hard for me to review is the lack of
> documentation to start with.  There are lists of policy managers, domain
> initializers, etc, and I don't know what they are.
> 
> Could you flesh out Documentation/tomoyo.txt and/or the variable, struct,
> and function definitions under security/tomoyo/ with some explanations?

I see. I'll try to update (but will need some time).

Thanks.
