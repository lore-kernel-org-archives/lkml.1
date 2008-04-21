Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYDUNNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYDUNNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYDUNNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:13:42 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:41905 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYDUNNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DzRmmkEFDnFK2CPr7JUwYxJv6GpxtPxAXdk3xx3iCKK1mpgUIJiOeQdOiwB4jGn6SZo8s8QV/iLPou1VtoEzH731njwkYvPCKiy7HAXU3ItM31G/dXkA0o+oT1egKq2cm/Cd9hq7h4V5UZ7yZhq5RcGC4aJwCg7YaN9tkJw8XF0=
Message-ID: <f7430a760804210613h69e4b560q774301a1152ef77d@mail.gmail.com>
Date: Mon, 21 Apr 2008 15:13:40 +0200
From: NoWhereMan <uncommonnonsense@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to ignore error LINK CRS method
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
In-Reply-To: <f7430a760804161154o77dd7fc5g622d3bbe4fa1183b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
	 <20080409161251.0c0e73e9.akpm@linux-foundation.org>
	 <1207824057.8704.12.camel@yakui_zhao.sh.intel.com>
	 <f7430a760804100523t6483dc0cn144429ee7024a7f2@mail.gmail.com>
	 <1208267385.12372.11.camel@yakui_zhao.sh.intel.com>
	 <f7430a760804150121ndfaf065j332ebf1cee3c572@mail.gmail.com>
	 <f7430a760804151538v410f7c64m21d90cb9da8e9baa@mail.gmail.com>
	 <f7430a760804161154o77dd7fc5g622d3bbe4fa1183b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch is working; cc'ing to ML

On Wed, Apr 16, 2008 at 8:54 PM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
> FYI it wasn't latest git but still rc7; I've fast-forwarded now to
>  rc9, but if no significant changes were made on that part of acpi I'm
>  sure it will work anyway
>
>
>
>  On Wed, Apr 16, 2008 at 12:38 AM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
>  > hi Zhao,
>  >
>  >  I've applied the patch to latest linus git, boot went flawlessly
>  >  (except the usual error messages about _CRS method) and both wireless
>  >  and USB work, so I'm assuming it worked.
>  >
>  >  I'm attaching my dmesg just for reference. I've enabled ACPI debugging
>  >  in my kernel config.
>  >
>  >  thank you a lot for your efforts with this bug
>  >
>  >
>  >
>  >  On Tue, Apr 15, 2008 at 10:21 AM, NoWhereMan <uncommonnonsense@gmail.com> wrote:
>  >  > On Tue, Apr 15, 2008 at 3:49 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
>  >  >
>  >  >  >  Will you please try the workaround patch and see whether the problem can
>  >  >  >  be fixed?
>  >  >  >  Thanks.
>  >  >
>  >  >  I will as soon as possible, thank you for your efforts!
>  >  >
>  >
>
