Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753745AbYLQFD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYLQFD5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYLQFDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:03:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:2405 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYLQFDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=R5khswH4y7qFgaMOE7l2AJO7npYaXRJHSNHt7/6tR4fjRc0GlGWmG4HQLepoKGMxcH
         F5FVl6EIlyyALltZ1qnUfeyulog8qPAQZbPIrZzL87I9hGDaXTp7HMKp57ggWrTh/YhA
         qMQypObBf4Tt1pIoemJ3qdUwbsg4nc8mwsgzA=
Message-ID: <84144f020812162103q75af883m980307a1dba6e3bc@mail.gmail.com>
Date: Wed, 17 Dec 2008 07:03:44 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/9] oprofile: port to the new ring buffer
Cc: "Robert Richter" <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sourceforge.net, mingo@elte.hu,
        rostedt@goodmis.org, "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <20081216154920.d6b922bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
	 <20081216154920.d6b922bb.akpm@linux-foundation.org>
X-Google-Sender-Auth: f0f1075c8ca45697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 1:49 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I'm not sure what to do about that, apart from finding (or building) a
> new alpha cross-compiler.
>
> What a PITA.   I do so wish that someone would maintain a suite of
> cross-compilers for kernel developers.

There's quite a few cross compilers for i386 here:

http://www.kernel.org/pub/tools/crosstool/files/bin/i386/
