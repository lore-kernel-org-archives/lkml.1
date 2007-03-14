Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXCNQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXCNQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXCNQ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:58:38 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42877 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751840AbXCNQ6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:58:37 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Ooops with suspend to RAM
Date: Wed, 14 Mar 2007 18:59:30 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200703140642.28390.ismail@pardus.org.tr> <20070314115047.GC18731@stusta.de>
In-Reply-To: <20070314115047.GC18731@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703141859.30555.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 13:50:47 Adrian Bunk wrote:
> On Wed, Mar 14, 2007 at 06:42:28AM +0200, Ismail Dönmez wrote:
> > Hi all,
> >
> > With latest GIT tree I am getting the following oops when I try to
> > suspend to RAM:
> >...
>
> Is this an old problem, or what was the last kernel that worked for you?

I changed my .config totally so I'll have to check with older kernels and get 
back to you. I hope to try latest -mm and 2.6.20 this weekend.

Thanks.

-- 
Happiness in intelligent people is the rarest thing I know. (Ernest Hemingway)

Ismail Donmez ismail (at) pardus.org.tr
GPG Fingerprint: 7ACD 5836 7827 5598 D721 DF0D 1A9D 257A 5B88 F54C
Pardus Linux / KDE developer
