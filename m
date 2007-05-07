Return-Path: <linux-kernel-owner+w=401wt.eu-S966523AbXEGUVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966523AbXEGUVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966518AbXEGUVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:21:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966515AbXEGUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:21:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=SW/3pQu4zRSXkCDhYhCFsVpKtlHz/94a2e9Nw4cQGYdPATDI1purAHOBPHOu16A3e
	V1m9xkei7xxdvqC7Jx6CA==
Message-ID: <463F8A3D.5050900@google.com>
Date: Mon, 07 May 2007 13:21:17 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Matti Aarnio <matti.aarnio@zmailer.org>, linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
References: <20070507145555.GG3883@mea-ext.zmailer.org>	 <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com> <a781481a0705070929q18525cbdp1e3b99705a7b18d4@mail.gmail.com>
In-Reply-To: <a781481a0705070929q18525cbdp1e3b99705a7b18d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/7/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
>> > In the  linux-kernel  -list subscribers domain popularity
>> > analysis I got following results:
>> >
>> >    2101 gmail.com
>> >      49 googlemail.com
>> >      46 gmx.de
>> >      41 redhat.com
>> >      33 yahoo.com
>> >      23 suse.de
>> >      22 gmx.net
>> >      21 comcast.net
>> >
>> >
>> > The  gmail  is so popular, that with their somewhat rudimentary
>> > inbound MTA software this kind of recipient masses take horrible
>> > time to feed in...  Mere 0.5-0.7 seconds per recipient, but..
>> [...]
>> How about some elitism here? Dedicate a certain number of streams to
>> everything-except-gmail, so MTAs from the 21st century can get their mail
>> faster, and set the rest on gmail-only. Slows down gmail and speeds up 
>> the rest?
> 
> Aargh ... what did us poor folk do to deserve this? I understand ~2000
> of those Gmail users are only spectators, but most others don't have a
> choice. In my case, my university doesn't allow mailboxes to go beyond
> a certain limit and only a couple of weeks worth of lkml would eat
> that up. And I suspect other free web mail servers that offer 3 GB of
> space too would be equally slower. But I do hope someone from Google
> listened to this -- half a second per recipient ... *sucks*.

I filed a bug on it, copying Matti's email. Whether it's easily fixable
or not, I have no idea.

M.
