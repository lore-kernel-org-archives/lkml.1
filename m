Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYL2WJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYL2WJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYL2WJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:09:44 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34081 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYL2WJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dfuQByhqTTPOV1woQOYNG2GM8Yfqgr6xsgWQxts9kzI12VcSlUQ3tAO2j+erglCcRK
         DBzPT3dvphLQ/rfUnHumxHo2nK7UuiuER4itPM3ZZg+GIaD8y4HJ2aVMemG2+ZorkVVh
         7htYSuqktFSXJVW/NnbvFsfwvTKvO0CBBeI1k=
Date: Mon, 29 Dec 2008 23:09:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081229220937.GC5829@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4959443f.09a1660a.44f3.2686@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka, note that I would be pleased to add statistical tracing on
this tracer, but I would need a hashtable, or an array, or a list, or whatever
iterable to insert the data into the stat tracing api.

But I don't know your projects about this... whether you wanted to use a section
or something else...

