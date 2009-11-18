Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZKRAVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZKRAVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbZKRAVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:21:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbZKRAVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:21:01 -0500
Message-ID: <4B033DA2.6080007@redhat.com>
Date: Tue, 17 Nov 2009 19:19:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 1/2] mm: Introduce coredump parameter structure
References: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com> <20091117235334.30900.97418.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117235334.30900.97418.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, it's not mm, but bimfmts.

Masami Hiramatsu wrote:
> Introduce coredump parameter data structure (struct coredump_params)
> for simplifying binfmt->core_dump() arguments.
> This also cleanup DUMP_WRITE() in elf_core_dump() by style issue.
>
> Signed-off-by: Masami Hiramatsu<mhiramat@redhat.com>
> Suggested-by: Ingo Molnar<mingo@elte.hu>
> Cc: Hidehiro Kawai<hidehiro.kawai.ez@hitachi.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Oleg Nesterov<oleg@redhat.com>
> Cc: Roland McGrath<roland@redhat.com>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

