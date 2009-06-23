Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZFWQKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZFWQKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZFWQKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:10:24 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:23382 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754100AbZFWQKX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:10:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0gosCqO43+b1js7Jl0+iSzdXRVZlkvQ9aimCyJFKbHTyNXmTj/kcSINjEy8ZTbV/wBultdAl7Q/El8lhnd2jPnK++EQvRAc4hCPyrNs7pQgUbc5voIGz4iT4hlEBHwTXtx39KBCzzrlic+y6qmcBf5lzaf/dSaGjYKZKHD9bbZw=;
Message-ID: <589165.9933.qm@web50102.mail.re2.yahoo.com>
X-YMail-OSG: p_vMdS8VM1mRGYrWM4HNvvHqtoqhQv5XmRy7CRLhdlKd7w87he8-
X-Mailer: YahooMailClassic/5.4.17 YahooMailWebService/0.7.289.15
Date: Tue, 23 Jun 2009 09:10:24 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] MAINTAINERS: pair names/addresses in EDAC-I82975X
To: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ranganathan Desikan <rdesikan@jetzbroadband.com>,
       "Arvind R." <arvind@acarlab.com>, bluesmoke-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 6/18/09, Joe Perches <joe@perches.com> wrote:

> From: Joe Perches <joe@perches.com>
> Subject: [PATCH] MAINTAINERS: pair names/addresses in EDAC-I82975X
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ranganathan Desikan" <rdesikan@jetzbroadband.com>, "Arvind R." <arvind@acarlab.com>, bluesmoke-devel@lists.sourceforge.net
> Date: Thursday, June 18, 2009, 12:54 PM
> Signed-off-by: Joe Perches <joe@perches.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fb94add..e139389 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2052,8 +2052,8 @@ F:   
> drivers/edac/i5400_edac.c
>  
>  EDAC-I82975X
>  P:    Ranganathan Desikan
> -P:    Arvind R.
>  M:    rdesikan@jetzbroadband.com
> +P:    Arvind R.
>  M:    arvind@acarlab.com
>  L:    bluesmoke-devel@lists.sourceforge.net
> (moderated for non-subscribers)
>  W:    bluesmoke.sourceforge.net
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
