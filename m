Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYKRVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYKRVV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKRVVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:21:48 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:64287 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYKRVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UaVR3BFJAD1N2y698CYaE7WUNiciVhnRpcwbhFiCzQB0UA/2rGaDIvqUAZ97RUgjuc
         FmqKU4oEaWhdnemFpxCRWMl8EJRfxuCQqQBTF56rCMQfvbSxogsoSmJC+IBDt7eZKJzE
         W9u8uLq9s5CL/fV2fnf0Xneu0bUJpaI1uQ618=
Message-ID: <fc262dee0811181313n35f39184ne438ddebb0225ba5@mail.gmail.com>
Date: Tue, 18 Nov 2008 22:13:30 +0100
From: "=?ISO-8859-1?Q?Fredrik_Markstr=F6m?=" 
	<fredrik.markstrom@avalonenterprise.com>
To: "Theodore Tso" <tytso@mit.edu>
Subject: Re: Developing non-commercial drivers ?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, Valdis.Kletnieks@vt.edu,
       "=?ISO-8859-1?Q?Fredrik_Markstr=F6m?=" 
	<fredrik.markstrom@avalonenterprise.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081118202057.GF29975@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
	 <63125.1227036333@turing-police.cc.vt.edu>
	 <20081118192942.3c676f0d@lxorguk.ukuu.org.uk>
	 <20081118202057.GF29975@mit.edu>
X-Google-Sender-Auth: 7e4ef04b3d36a3e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

I'm the one that started this thread (I'm also responsible for the
screwed up subject :)

Unfortunately I can't disclose our client simply because I have not
asked for their permission.
Anyway strongly doubt they want to do something illegal or wrong, but
a lot of people obviously thinks binary drivers are accepted by the
Linux community and licensing. It sure would be nice if this could be
stated more explicit in some official FAQ.

Your (the Linux Foundations) web gives the impression that you protect
Linux against external interests (like my clients),  but do you have
to authority to work the other way ? Can you make deals or promises on
behalf of the copyright owners of the Linux kernel ? I doubt that but
might be wrong.

Anyway, I'm not sure how the Linux Foundation can help in this case,
if you can explain that, I sure will bring it up with our client.

/Fredrik


On Tue, Nov 18, 2008 at 9:20 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Nov 18, 2008 at 07:29:42PM +0000, Alan Cox wrote:
>>
>> Not entirely. There are several reasons this may occur
>> - They could have something genuinely new - unlikely to be honest
>> - They could think they have something genuinely new but don't
>> - They may not yet have filed some relevant patent applications in which
>> case they have to worry about secrecy
>>
>> and other reasons.
>>
>
> If I had to guess, they're probably doing some kind variant of TCP,
> Crypto, or some other kind of networking offland trick.  There really
> isn't much else you can do that might be considered new in an ethernet
> controller.  And it's probably not new.
>
>> Probably they should talk to the Linux Foundation. I'm not sure that
>> assuming they are clueless is the first step. Understanding the problem
>> as they see it is more important and probably something the Linux
>> Foundation can help with and under a business to business framework.
>
> Well, I'm from the Linux Foundation, and I'm here to help.  :-)
>
> Seriously, if they are willing to talk to someone, we're certainly
> willing to give them some free advice.  My guess is that's not very
> likely, however.
>
>                                                - Ted
>
>
