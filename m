Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXIMI5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXIMI5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXIMI5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:57:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:54922 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbXIMI5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YIa7ARWqeyoJa/tQMwJlDMjYU9OswpMzywTNp9DaA1V+a8qGDwCqceH9bQ/zusNUJ65OJfmCAvkHWQK7AhmhzVjZiru720Ck0wJrOPEioPmGlc8EaskNgXfdIjHwzgKlCaaMbF9mJL6xsU5Mdcg8kn/30Yx94Oz6NGn6H9G415U=
Message-ID: <46E8FB0F.3030904@gmail.com>
Date: Thu, 13 Sep 2007 10:55:43 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nigel Kukard <nkukard@lbsd.net>, Dave Jones <davej@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: SATA problems
References: <4671366B.7090702@lbsd.net>	<46716B1D.1070902@garzik.org>	<20070614182854.GC1223@redhat.com>	<20070618200703.GB13344@redhat.com>	<46776223.3050402@lbsd.net>	<46D68CC2.3030206@lbsd.net> <20070910020243.1101cf7a.akpm@linux-foundation.org>
In-Reply-To: <20070910020243.1101cf7a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 30 Aug 2007 09:24:18 +0000 Nigel Kukard <nkukard@lbsd.net> wrote:
> 
>> Hrmmm,
>>
>>>>  > 
>>>>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>>>>  >  > > 0x0001c807
>>>>  >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>>>>  >  > > 0x0001c807
>>>>  > 
>>>>  > Unrelated to the other error, but I've been meaning to ask for a while..
>>>>  > If this is 'abnormal', why does every SATA box I've seen do it?
>>>>
>>>> *crickets*

It's removed (finally).  :-)

-- 
tejun
