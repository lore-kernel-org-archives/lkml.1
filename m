Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZKKIEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZKKIEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZKKIEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:04:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbZKKIEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:04:15 -0500
Message-ID: <4AFA6E50.7030808@zytor.com>
Date: Tue, 10 Nov 2009 23:57:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <4AF9E61B.5090407@zytor.com> <20091110222031.GA22911@elte.hu> <20091110224222.GA28648@1wt.eu> <4AF9ED78.3000106@zytor.com> <20091111055220.GA560@1wt.eu> <4AFA569E.9040206@zytor.com> <20091111063617.GD560@1wt.eu>
In-Reply-To: <20091111063617.GD560@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 10:36 PM, Willy Tarreau wrote:
>>
>> Do you have *any* *evidence* *whatsoever* for that assertion?!
> 
> No, just basic feeling based on implementation cost and difficulty
> vs gains as I explained.

Quite on the contrary; in hardware it would be pretty hard to *not* do
the right thing.

>> I personally will consider something that doesn't implement proper
>> security check to be a potential security hole and will NAK the patch.
> 
> Even in the case of the NOPL instruction ? I clearly don't see
> the potential security hole !
> 

You have it backwards.  Prove that there *isn't* one and we'll talk.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

