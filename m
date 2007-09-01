Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbXIAUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbXIAUjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXIAUjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:39:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:9912 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXIAUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tEYRVMEIjY1iLFH49qeCrnLpKjqYmEiq+hUIe4dy9cYPuEC2h7JNi2iXW52w+t425MgnXyrWatbJjAy+EWWEZ1MZfbEqlYaBKknkmQ3TPqCYDRmtW50rW4UZRICtcyEn71rivRY3PRFvg6cfj9/hzSo2rB14a+IBT2bVqg915ig=
Message-ID: <46D9C6A8.7070600@gmail.com>
Date: Sat, 01 Sep 2007 22:08:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] Net: ath5k, use int as retval
References: <2713029743177393055@pripojeni.net> <2440910618305782004@pripojeni.net> <20070830124054.GC5140@tuxdriver.com>
In-Reply-To: <20070830124054.GC5140@tuxdriver.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville napsal(a):
> On Tue, Aug 28, 2007 at 12:00:09PM -0400, Jiri Slaby wrote:
>> ath5k, use int as retval
>>
>> Convert some functions to return int and proper negative return value on
>> error as we are used to.
> 
> Since I didn't apply 1/5, this one didn't apply either.  It seems
> fine overall, so if you rediff I'll be happy to apply.

Ok, I'll do it, thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz

