Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0CBPSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:18:14 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43587 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0CBPSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fS/ugFJl8FAM3awUoWZbqFPoVJH5DmOf/Yr5RpkBz9aA8q0ElETVLJZL/fu1rWtrb/
         qZLl9cMuW3zz3IqQHYmVpCLxf6aCzHddoifOBDQQEHOYKCs6uyWw4X7iTF9xnWerwMgz
         CW8LrBwmVLQZFTtDE9qpoLvsou6AnQfQlCFxw=
MIME-Version: 1.0
In-Reply-To: <20100228152839.GA3063@localhost.localdomain>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
	 <20100227221310.GA5455@localhost.localdomain>
	 <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
	 <20100228152839.GA3063@localhost.localdomain>
Date: Tue, 2 Mar 2010 16:18:11 +0100
X-Google-Sender-Auth: dea7ffc852f6f036
Message-ID: <9cdbb57f1003020718y6d019e06l93aecb918532e30a@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 66/66] arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: 
	Checkpatch cleanup
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/28 Jeff Dike <jdike@addtoit.com>:
Hi Jeff,
   and thanks for your reply.

> checkpatch violations.  I cleaned up a lot of it while making other
> changes in the area.  This sort of thing I think is reasonably
> worthwhile, but dumping in a whole lot of checkpatch changes doesn't
> help anything and it just pollutes the change history.

   Yep, I talked about side effects (i.e git-blame) with Alessandro (Rubini).
   If you think it could be useuful I can check all the subtree. Send
you patches (if any).
   You can merge piece of them as soon as you modify files with real
patches, so you
   don't have to do the boring business. I don't care to have credits
about 'em, and it's not
   a problem if you will not use them.

Thanks a lot,
Andrea
