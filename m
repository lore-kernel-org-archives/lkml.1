Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYEDBBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYEDBBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 21:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYEDBBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 21:01:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:8685 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYEDBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 21:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZMPARx5q6PHF9mRza0rMXr1YXMs69YPMCWL3xWppzhbMzOTIYEfhYtvGLxkx1WXn56nBWSDmqL+rs4HWQpwWDdvYWtVHAPxTmmKT6Il6ZiAjliaKJ/u4mSYnL2AOfK0mtF49iJzm95U+mqHDackmm6DrVlk60ZHiQNNMN9eVHIk=
Message-ID: <75b66ecd0805031801s27143437r67ce37b4bc9fdb56@mail.gmail.com>
Date: Sat, 3 May 2008 21:01:00 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.4 usage statistics
Cc: "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <481771B8.9070105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428202433.GA13417@hera.kernel.org>
	 <20080428205631.GA2813@cs181133002.pp.htv.fi>
	 <20080428211812.GA19093@1wt.eu> <481771B8.9070105@s5r6.in-berlin.de>
X-Google-Sender-Auth: 77606cec32e6ddee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 3:06 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>  Another reason which I read here and there and don't know how real the
> issue is:  2.6's minimum possible footprint is said to be unable to compete
> with 2.4 for really resource restricted applications.
>
>  Could it actually be that 2.4 outnumbers 2.6 in embedded installations?

Possibly.  However many embedded applications have real time
constraints so are using 2.6 these days.  Both vanilla and -rt patched
2.6 beat the pants off 2.4 in this area.

Lee
