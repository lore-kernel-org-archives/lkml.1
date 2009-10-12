Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZJLQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZJLQlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZJLQlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:41:36 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:40421 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbZJLQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=xYsH/XtkQlO/dCt1eiEqvga50/zuqrJMW7EtpnQI6JyCYrcJqRevUXIx7igkgeUkk2
         y/HLb4xw07+jZgYGKxxfpAlf+hBTpIjFSqZ09JxA/inu1i7jh6W8AGM1lmkGZBrgrlRo
         hq1iMSguNap+2bA11D/a6iZJLrBFmOVAT9w3k=
MIME-Version: 1.0
In-Reply-To: <20091012163802.GD20786@sortiz.org>
References: <1255197244-20121-1-git-send-email-vapier@gentoo.org> 
	<1255197244-20121-2-git-send-email-vapier@gentoo.org> <20091012163802.GD20786@sortiz.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 12 Oct 2009 12:40:39 -0400
Message-ID: <8bd0f97a0910120940r319c340bi367f5350e21d87d4@mail.gmail.com>
Subject: Re: [PATCH 2/5] LED Support for ADP5520/ADP5501 MFD PMICs
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:38, Samuel Ortiz wrote:
> On Sat, Oct 10, 2009 at 01:54:01PM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Does this driver look fine to you ?

note that this is the same one that was sent a month ago followed by
the define name tweaks a week ago
-mike
