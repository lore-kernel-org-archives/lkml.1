Return-Path: <linux-kernel-owner+w=401wt.eu-S937827AbXGRXqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937827AbXGRXqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937617AbXGRXnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:43:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:19340 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937610AbXGRXnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PmO01nCMiBh1Khxsrnp+vU4ueAxOAxRzwDGngyvzAfWo3tSVsfVsvs4+r6YBCQzGRs+GLs95MIIV1LBLPWp1pqmxYDA0ruV8EdBvsqY0xRWknx2xPqvJGx9J/Ywv75JUwijKOpt9xdSIinR4NJgh4ihrOwMtgVLcWj4GcdQfLGg=
Message-ID: <9a8748490707181643v2ad6b0d0ld44226a367a6f937@mail.gmail.com>
Date: Thu, 19 Jul 2007 01:43:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 1/5] HOWTO: add Japanese translation of Documentation/HOWTO
Cc: linux-kernel@vger.kernel.org, "Tsugikazu Shibata" <tshibata@ab.jp.nec.com>,
       "IKEDA Munehiro" <m-ikeda@ds.jp.nec.com>
In-Reply-To: <11848012031961-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070718232346.GB4620@kroah.com>
	 <11848012031961-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
>
> Add the japanese translation of the Documentation/HOWTO file.
>

A few comments below.

> Signed-off-by: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
> Cc: IKEDA Munehiro <m-ikeda@ds.jp.nec.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  Documentation/ja_JP/HOWTO |  650 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 650 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ja_JP/HOWTO
>
> diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
> new file mode 100644
> index 0000000..b2446a0
> --- /dev/null
> +++ b/Documentation/ja_JP/HOWTO
> @@ -0,0 +1,650 @@
> +NOTE:
> +This is Japanese translated version of "Documentation/HOWTO".

I'd suggest "This is a Japanese translated version ..." or perhaps
"This is a version of Documentation/HOWTO translated into Japanese".


> +This one is maintained by Tsugikazu Shibata <tshibata@ab.jp.nec.com>

I'd write "This document is maintained by ..."

> +and JF Project team <www.linux.or.jp/JF>.

"and the JF Project team ..."

> +If you find difference with original file or problem in translation,

How about "If you find any difference between this document and the
original file or a problem with the translation,"

> +please contact maintainer of this file or JF project.

"please contact the maintainer ..."

> +
> +Please also note that purpose of this file is easier to read for non
> +English natives and not to be intended to fork. So, if you have any
> +comments or updates of this file, please try to update Original(English)
> +file at first.


Shouldn't this be something along the lines of
"Please also note that the purpose of this file is to be easier to
read for non English (read: Japanese) speakers and is not intended as
a fork. So if you have any comments or updates for this file please
try to update the original English file first."


<snip - can't comment on the actual Japanese text>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
