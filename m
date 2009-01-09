Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZAIGGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZAIGGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZAIGGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:06:34 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:42569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZAIGGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HKlvZH4xkqKlBOXYrG8T25K1u1UFL8jubGJopTVhNKLRqXuAxVXlMifheL4eUMfyVx
         EmbPPrJA/1oqWhbIhk7/3gEuJ0l5gZcxlD8BZF4BuZSlXtuWBCRI0wUwhYNiEKbZkd5u
         xcG3Hmo15jE8D3st0KTMAw39VIr5h06/DWpaY=
Message-ID: <661de9470901082206p7eff2e91p73a0b8589377cdcb@mail.gmail.com>
Date: Fri, 9 Jan 2009 11:36:32 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] cgroups: consolidate cgroup documents
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Menage" <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <20090109112904.a002ff72.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4966B383.3030106@cn.fujitsu.com>
	 <20090109112904.a002ff72.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: cd0c01a2c6c3595c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 7:59 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> On Fri, 09 Jan 2009 10:16:35 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> > Move Documentation/cpusets.txt and Documentation/controllers/* to
> > Documentation/cgroups/
> >
> > This inlined patch is generated with git-show -M (rename detected)
> > and is for review, and the attached one is for apply.
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>
> Oh, I love this patch. Thank you!
>
> (about memcg part)
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>

Me too

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
