Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZKISEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZKISEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZKISEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:04:11 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48124 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZKISEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AeYQsosPcsXXbIYoiNsvbJ3e3Vc51nYEHrNIpcXoTZRQjtsfjw1eBkpDxzfe1kT7r7
         l+8crmDkJWMKjDPJhkjOiJ72QCBoYO54gb0D9Y20arHPzn+l7YVG/eqqyR/il8VZF2cM
         RAyLWEdGM0TZrGmj66ZqkOBdBZ8/xonlIQIAA=
Date: Mon, 9 Nov 2009 19:04:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] ksym_tracer: Support read accesses independent of
	read/write.
Message-ID: <20091109180414.GA5152@nowhere>
References: <20091109083733.GA25848@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109083733.GA25848@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 05:37:34PM +0900, Paul Mundt wrote:
> All of the infrastructure already exists to support read accesses
> for platforms that support a read access independently of read/write
> (such as in the case of the SuperH UBC). This just trivially hooks
> up the read case by itself.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
>


Queued, thanks Paul.

