Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXCKWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXCKWLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbXCKWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:11:48 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:36974 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932891AbXCKWLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:11:47 -0400
Message-ID: <45F47EA2.6040708@gmail.com>
Date: Sun, 11 Mar 2007 23:11:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jikos@jikos.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>  <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com>  <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com> <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com> <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz> <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz> <45F4770F.4090902@gmail.com> <Pine.LNX.4.64.0703112243560.26904@twin.jikos.cz> <45F47A45.5080006@gmail.com>
In-Reply-To: <45F47A45.5080006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Jiri Kosina napsal(a):
>> Hmm, strange, I did bet that this would have solved the problem, as 
>> the code is for sure bogus and could be causing these kinds of 
>> problems (I 
> 
> Hmm, so I'll check this out again to eliminate human factor.

verified.

-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
