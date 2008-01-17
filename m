Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYAQKOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYAQKOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYAQKOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:14:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:4998 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYAQKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Kk3XwUdqB5Vq1PPxD9S/wSqhLSlZEqH2jzgpP8sCbP5eSBsSQi/gc+rCxzDMGmD0DG/hMjx20hgMCiowVxyKw9mlFcp2Hx5tfBOOg8XQM+7MZgpcaTnH3eJeqHNckFGGPnqK8aEPa0g9LbaSzqz1sVNjGmq/pAiOF54256vBhlg=
Message-ID: <478F2A82.3090102@gmail.com>
Date: Thu, 17 Jan 2008 11:14:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sergei Organov <osv@javad.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/5] Char: mxser, remove special baudrate processing
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com> <87tzlfnm1h.fsf@osv.gnss.ru>
In-Reply-To: <87tzlfnm1h.fsf@osv.gnss.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2008 04:30 PM, Sergei Organov wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
>> If you, Sergei, can test it, it would be great. [Note, that this is actually
>> a patch for mxser_new after renaming.]
> 
> Where is the reference git tree for this patch? Or, in other words,
> which tree do I use if I want to test this patch (I'm afraid the latest
> I've ever built, 2.6.19.1, is too old for this material)?

Ah sorry, at least 2.6.20 is needed for that stuff. Nevermind, anyway thanks a 
lot for your time.
