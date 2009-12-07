Return-Path: <linux-kernel-owner+w=401wt.eu-S935550AbZLGUjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550AbZLGUjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935036AbZLGUjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:39:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46653 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934866AbZLGUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A6mW9Bo7W7t6OdtbT8yGi3Kzpj4mhTqbL+MLw5bCYvSZK7sCEVL0oa1blH4W2xmlJH
         w/eou7QiLOpg8mfBv6s2moKPRfMUmCOHG8yfi3U8+m+9kYtHv9lKnL3fNFAn0Vk38LLy
         tRWwB0vpY3vdKJ147aGN0aCuBuI2U0xN8PxHU=
Date: Mon, 7 Dec 2009 21:39:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] tracing: Extract calls to
	trace_define_common_fields()
Message-ID: <20091207203918.GF5049@nowhere>
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB173.8080204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CB173.8080204@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:40:35PM +0800, Li Zefan wrote:
> Call trace_define_common_fields() in event_create_dir() only.
> 
>    text    data     bss     dec     hex filename
> 5456157 2005772 7103796 14565725         de415d vmlinux.o
> 5454538 2005772 7103796 14564106         de3b0a vmlinux.o
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

