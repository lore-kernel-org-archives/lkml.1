Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXI2W60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXI2W60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 18:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbXI2W6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 18:58:19 -0400
Received: from main.gmane.org ([80.91.229.2]:34239 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbXI2W6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 18:58:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Date: Sat, 29 Sep 2007 23:55:01 +0100
Message-ID: <yw1xodflrsje.fsf@thrashbarg.mansr.com>
References: <20070929122530.5c45f743@hyperion.delvare> <20070929035156.cd6fe860.akpm@linux-foundation.org> <20070929112928.56a04641.randy.dunlap@oracle.com> <20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070929131317.6a8609dc.randy.dunlap@oracle.com> <20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:jc5qHpkzju+0ewhlSmg3beAQA+U=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

>> > > Let's kill it, please.  (i.e., ACK)
>> > 
>> > But ... why?  What value could needless parens provide?
>>
>> Who says that needless parens could provide value?
>
> Jean, which is why he submitted the patch.
> You, implicitly, by acking a patch saying those parens are bad.
> But not me ... I don't think this patch is merge-worthy.

Would also add rules like "don't put parens around the word device"
etc?  There are countless silly things one could do, and we can't
explicitly prohibit all of them.

-- 
Måns Rullgård
mans@mansr.com

