Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0CBPUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:20:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0CBPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:20:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=roJT+25qGCm8YtB4klvJgHnZdeLX9cKNHctGQiIKeJ+UiZVQEESMjESVK/KRzefm16
         N571j7M7CkbbVD19psKDIz+f8Udyg5hJWMerXieqrGQmdKoOg08ryX1JHXBpEeuuBexS
         ZVnssfZlROQlTWwOfraIdHNSFO0kV1CUu4Sso=
MIME-Version: 1.0
In-Reply-To: <20100228204506.GQ30031@ZenIV.linux.org.uk>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
	 <20100227221310.GA5455@localhost.localdomain>
	 <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
	 <20100228204506.GQ30031@ZenIV.linux.org.uk>
Date: Tue, 2 Mar 2010 16:20:39 +0100
X-Google-Sender-Auth: 17708edeae1bbd77
Message-ID: <9cdbb57f1003020720i15eec6bcg56ecb15c0e17e1e5@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 66/66] arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: 
	Checkpatch cleanup
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/28 Al Viro <viro@zeniv.linux.org.uk>:
Hi Viro,
    thanks a lot for your reply.

> Note to gregkh: the next time you give a talk like that, consider including
> "spamming l-k with sixty-odd solitaire sessions^W^Wwhitespace-removal patches
> can lead to considerable annoyance"...

   As you can see in the video, Greg talked about - just and only -
Staging Drivers.

   It's all my fault if someone is bored with my patches.

Thanks a lot for your work,
Andrea
