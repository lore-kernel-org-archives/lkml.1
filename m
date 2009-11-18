Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbZKRTMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbZKRTMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932462AbZKRTMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:12:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbZKRTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:12:37 -0500
Date: Wed, 18 Nov 2009 11:12:12 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Edward Shishkin <edward.shishkin@gmail.com>
cc: reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: reiser4 for 2.6.33?
In-Reply-To: <4B03FB99.6070705@gmail.com>
Message-ID: <alpine.DEB.2.01.0911181054250.27639@bogon.housecafe.de>
References: <alpine.DEB.2.01.0911171420480.27639@bogon.housecafe.de> <4B03FB99.6070705@gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+XYuv3SkR/Mgqf7i9t6EP08Q/SxfQYAl/M2Fn
 6rinjZCmWXI7/cLf7nF7SY5qprsOjjigZ+xSXqhAzqamvy/gq7
 StjcgIjMMJuyd+buxRJlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 at 14:50, Edward Shishkin wrote:
> (a) plugin design document;
> (b) full description of what is going on in respond to memory
>    pressure notifications;
> 
> The (a) is not yet ready and I don't have a time to explain
> personally to everyone why the plugin stuff is not crappy.

Is this still a must-have? I.e. are there still strong objections against 
the plugin design? And even if so, most of this happens in fs/reiser4 
anyway I suppose, so the "evil" plugins are well contained :)

As for (b), can't this be documented at a later point as well? 

What about the technical issues, mentioned in the latest TODO list[0] 
earlier this year? Are there any real show-stoppers left?
Andrew (Cc'ed) had this in -mm for a longer time now, maybe he can
comment (once again) what's left to do from his POV?

Thanks,
Christian.

[0] http://marc.info/?l=reiserfs-devel&m=124069989217533&w=2
-- 
BOFH excuse #323:

Your processor has processed too many instructions.  Turn it off immediately, do not type any commands!!
