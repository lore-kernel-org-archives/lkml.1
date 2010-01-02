Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404Ab0ABXoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0ABXoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876Ab0ABXoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:44:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0ABXoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:44:06 -0500
Message-ID: <4B3FDA38.2070509@nerdbynature.de>
Date: Sat, 02 Jan 2010 15:43:52 -0800
From: Christian Kujau <lists@nerdbynature.de>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1pre Thunderbird/3.0
MIME-Version: 1.0
To: tytso@mit.edu, Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org> <20100102210653.GH5076@nowhere> <20100102233603.GO828@thunk.org>
In-Reply-To: <20100102233603.GO828@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/7+gq9jaxIjF8PxohDFGJzxSXyN0nFCpHEEtN
 UNRaPDlyViJALP3JkaKyfPyw0a5o1PzfDENogb8bxWEMA4gQdT
 XMH0C9r2Y0IbnEvVlqhag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tytso@mit.edu wrote on 2010-01-02 15:36 :
>> Thanks! I'm going to test it now. I've been running a stress test
>> from Chris Mason which basically checks races on parallel writes/read.
>
> Hmm, which test is this?

http://oss.oracle.com/~mason/stress.sh, IIRC.

Christian.
-- 
make bzImage, not war
