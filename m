Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbZDXHl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbZDXHl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZDXHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:41:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:37889 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZDXHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ovc3Ty2El0YRlBW8MGV63Z/zQHHklmdeThgP+REM8GKsusWL/ui0rD5KTE3Pvz48sT
         6eEaNhZ/x6vCNhCp8ikqRnyV2lWn9f1c/VdiCefGYjgg4+Ps7H8c1h3XVv9Xl2zsP1Ci
         aNwN5gHsiMdvoZ3xnoW87mkfo2GeZPCBHTGwU=
MIME-Version: 1.0
In-Reply-To: <20090424071853.GG8633@ZenIV.linux.org.uk>
References: <20090423191934.GW1926@parisc-linux.org>
	 <1240556813-8739-1-git-send-email-abogani@texware.it>
	 <1240556813-8739-2-git-send-email-abogani@texware.it>
	 <20090424071312.GE8633@ZenIV.linux.org.uk>
	 <20090424071853.GG8633@ZenIV.linux.org.uk>
Date: Fri, 24 Apr 2009 09:41:08 +0200
X-Google-Sender-Auth: 1b9da5537e575ad9
Message-ID: <63a49ef40904240041n1af201e0k41b8436bb91dad41@mail.gmail.com>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
From: Alessio Igor Bogani <abogani@texware.it>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/24 Al Viro <viro@zeniv.linux.org.uk>:
[...]
> commit 208f6be8f9244f4a3e8de7b4c6ca97069698303a in
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/
>
> if you want to see the version after that change (or wait for linux-next
> to pick it).

Thank Sir.

Ciao,
Alessio
