Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbZGXAV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbZGXAV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZGXAV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:21:57 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:39892 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZGXAV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=V8+FFlsWpLB44ZelCQJvHsbJOwbmZGZQjvlCLN3nR7t29fu+yP/hOnSu/3KAKi+wUz
         ALAzR8UC/f+k578dZSzuPviX4GEUi2AqSN10ZRtOdOFXjeOyjewoanXiemn1MJXO+De4
         jbdQAw0cYrI8dZypT1ziypyFjCr81tMQmxuok=
MIME-Version: 1.0
In-Reply-To: <200907240145.31935.rjw@sisk.pl>
References: <200907240145.31935.rjw@sisk.pl>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 23 Jul 2009 17:21:36 -0700
X-Google-Sender-Auth: 621418424a484483
Message-ID: <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
Subject: Re: [Regression] kdesu broken
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
> discussion about that, but I can't find it right now.  Any clues?

See the thread starting here: ("possible regression with pty.c commit")
   http://lkml.org/lkml/2009/7/11/125
