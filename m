Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYCCXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYCCXAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYCCXAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:00:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYCCXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:00:14 -0500
Message-ID: <47CC82D0.404@redhat.com>
Date: Mon, 03 Mar 2008 17:59:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       systemtap@sources.redhat.com, jkenisto@us.ibm.com
Subject: Re: [PATCH][2.6.25-rc2-mm1] fix a null pointer bug in register_kretprobe
References: <47CC7B1C.1060305@redhat.com> <20080303143610.3a8c2f4b.akpm@linux-foundation.org>
In-Reply-To: <20080303143610.3a8c2f4b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 03 Mar 2008 17:26:36 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> This:
> 
>> Subject: [PATCH][2.6.25-rc2-mm1] fix a null pointer bug in register_kretprobe 
> 
> implies (to me) that the patch fixes a bug which is only in -mm.  But
> afacit this is a bugfix against mainline, yes?

Yes, that bug is also in mainline...

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

