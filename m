Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXDZH2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXDZH2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXDZH2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:28:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34540 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416AbXDZH2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=suu9RQgioOujOGV+30ExfrtaMf1nStXqWrb7AM+fRB+3qyuJrSdTL046favgwiWlVqxtFzMf+iuGgKxqoleIQbcQH2IwO0RLHMFX9zbFEvCmK5vvbB16VfWo1/0mSnzWVLWrAJ1Pxk6ENDr7ToN8vBE3IOeFeJB8L/Gr4rufJiI=
Message-ID: <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
Date: Thu, 26 Apr 2007 10:28:07 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: nigel@nigel.suspend2.net
Subject: Re: Back to the future.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1177567481.5025.211.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
X-Google-Sender-Auth: a0ef5158aa43fc4c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> 3) Someone else steps up to the plate and tries to merge Suspend2 one
> bit at a time.

So which bits do we want to merge? For example, Suspend2
kernel/power/ui.c, kernel/power/compression.c, and
kernel/power/encryption.c seem pointless now that we have uswsusp.
Furthermore, being the shameless Linus cheerleader that I am, I got
the impression that we should fix the snapshot/shutdown logic in the
kernel which Suspend2 doesn't really address?

                                Pekka
