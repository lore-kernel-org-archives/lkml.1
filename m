Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab0APCa1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384Ab0APCa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:30:27 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62794 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab0APCa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q/UA+tBbJjO3xaNE/MtMMn/pS+hf3YnIQJYN5JEDUELa4ei5Se9QL3pZyr2zVOlCaS
         0CTbzFUMjHhZE0v8v/FjrC0tlqDdeG+89Fm5mUjt/ERy6MPKZtMB3DJ9FvZXbf7GhfOF
         u1OmAG/7Krpn+yiXQkUYZrZsq2gFA/RrQfQlQ=
Subject: Re: [staging/hv] why it not follow kernel codingstyle?
From: "Figo.zhang" <figo1802@gmail.com>
To: bn@niasdigital.com, hjanssen@microsoft.com, haiyangz@microsoft.com
Cc: gregkh@suse.de, Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4650630.501001263607923679.JavaMail.coremail@bj126app13.126.com>
References: <4650630.501001263607923679.JavaMail.coremail@bj126app13.126.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 10:32:39 +0800
Message-ID: <1263609159.2562.16.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> > i am not familiar with the Hyper-V. But happy to see Greg Kroah-Hartman to push
> > the author to motify it follow the Kernel Codingstyle, or apply to merge to main tree
> > until it follow it.
> > Now it  has made the Codingstyle rule, anyone should follow it , right?


local variable and function use like "ThisVariableIsATemporaryCounter"
is very very ugly and brain damaged (only Microsoft use it).

Best,
Figo.zhang
Henan University of Science and Technology





