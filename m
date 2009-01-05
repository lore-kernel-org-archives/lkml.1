Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZAEOxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZAEOxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZAEOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:51:15 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:57561 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZAEOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DJJGcwA580EMdVrgoc62ywwATMwpH+nOF5iSBXpyp2oF4FjodIzKsFwXXinacvA39h
         gxoMtNXra9xiqL8tVw1Nw17UaryPCmHZK8lQFVVwXKvxC5qMoMmaEE+ML5q9sCCYsrAe
         mMza5e1V+dca3hiw5Eo6JUvjF+1xwrAhtccVY=
Message-ID: <49621E5C.5080701@gmail.com>
Date: Mon, 05 Jan 2009 15:51:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
References: <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org>
In-Reply-To: <20090105092619.GA3699@cmpxchg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 10:26 AM, Johannes Weiner wrote:
> (or bdata is NULL).

Confirmed, see http://lkml.org/lkml/2009/1/3/204
