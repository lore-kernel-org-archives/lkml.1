Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZJ0N7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZJ0N7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZJ0N7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZJ0N7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:59:32 -0400
Message-ID: <4AE6FCB7.5020801@redhat.com>
Date: Tue, 27 Oct 2009 09:59:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: gitignore: arch/x86/lib/inat-tables.c
References: <4AE64A02.9010403@ct.jp.nec.com>
In-Reply-To: <4AE64A02.9010403@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto<h-shimamoto@ct.jp.nec.com>
> 
> Ignore generated file arch/x86/lib/inat-tables.c.
> 
> Signed-off-by: Hiroshi Shimamoto<h-shimamoto@ct.jp.nec.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thanks!

> ---
>   arch/x86/lib/.gitignore |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>   create mode 100644 arch/x86/lib/.gitignore
> 
> diff --git a/arch/x86/lib/.gitignore b/arch/x86/lib/.gitignore
> new file mode 100644
> index 0000000..8df89f0
> --- /dev/null
> +++ b/arch/x86/lib/.gitignore
> @@ -0,0 +1 @@
> +inat-tables.c

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

