Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZDUFrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZDUFrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZDUFrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:47:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:13274 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZDUFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sh4KwBsUrJeWERypDfHuBlv2M7awtF4YJ43f7aCtmPoFRw7DYdBwoJhMqJ0vF7622H
         XYtPuksRDlQRSybGcMPqkdvgPKqBLgWSZFMtb77cLhY3otJih5pNk5tCyH4IgVAMiOkg
         dIKrqhmm3nTPlwU3BE9BoPXXyx3bqMLvyAAx0=
MIME-Version: 1.0
In-Reply-To: <20090421101855.F10D.A69D9226@jp.fujitsu.com>
References: <20090418154207.1260.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.1.10.0904201300140.1585@qirst.com>
	 <20090421101855.F10D.A69D9226@jp.fujitsu.com>
Date: Tue, 21 Apr 2009 08:47:35 +0300
X-Google-Sender-Auth: ff00e97c73b8197c
Message-ID: <84144f020904202247y59e991abta7be65749814f46c@mail.gmail.com>
Subject: Re: AIM9 from 2.6.22 to 2.6.29
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Apr 21, 2009 at 4:20 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Sat, 18 Apr 2009, KOSAKI Motohiro wrote:
>>
>> > > Here is a list of AIM9 results for all kernels between 2.6.22 2.6.29:
>> > >
>> > > Significant regressions:
>> > >
>> > > creat-clo
>> > > page_test
>> >
>> > I'm interest to it.
>> > How do I get AIM9 benchmark?
>>
>> Checkout reaim9 on sourceforge.
>
> sourceforge search engine don't search reaim9 ;)
>
>
> http://sourceforge.net/search/?words=aim9&type_of_search=soft&pmode=0&words=reaim9&Search=Search

I can only find "reaim7" so maybe Christoph meant the aim9 suite here:

  http://aimbench.sourceforge.net/
