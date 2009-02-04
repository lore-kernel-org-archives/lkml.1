Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZBDJNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZBDJNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZBDJNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:13:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:57330 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754582AbZBDJM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:12:58 -0500
Date: Wed, 4 Feb 2009 10:12:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Menage <menage@google.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Li Zefan <lizf@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, rdunlap@xenotime.net
Subject: Re: [PATCH] trivial: fix where cgroup documentation is not correctly
 	referred to
In-Reply-To: <6599ad830902032338q7018112cm499b0b6e83308707@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0902041012250.11630@jikos.suse.cz>
References: <498879F1.9040009@xenotime.net>  <1233694085-23893-1-git-send-email-cascardo@holoscopio.com>  <4988EADB.4050508@cn.fujitsu.com> <6599ad830902032338q7018112cm499b0b6e83308707@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Paul Menage wrote:

> >> cgroup documentation was moved to Documentation/cgroups/. There are some
> >> places that still refer to Documentation/controllers/,
> >> Documentation/cgroups.txt and Documentation/cpusets.txt. Fix those.
> > After grep, I think there's no wrong ref anymore.
> > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Paul Menage <menage@google.com>

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs
