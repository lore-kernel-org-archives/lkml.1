Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZJLAUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZJLAUY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 20:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZJLAUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 20:20:21 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:45359 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZJLAUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 20:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hXTq8hSJ5oNv9e5l4Pmrf5s7S41Wx8ZRFiZrUuQFVDu7btAZXciXQmPgc0Nt6LUerV
         T5tCr5iUO+LOfidHpr1pDhINH28zSlMB3ciMbWFZfiKlUpvX1Yae+bRdFcm/DzIOi2Id
         XSQq40Pof4LNCbHE7xdQdr514V11BRhyhziBE=
MIME-Version: 1.0
In-Reply-To: <L6tb-VyKHZK.A.oyE.O1l0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	 <L6tb-VyKHZK.A.oyE.O1l0KB@chimera>
Date: Sun, 11 Oct 2009 20:19:43 -0400
X-Google-Sender-Auth: 74a830969b7c1077
Message-ID: <b6c5339f0910111719m58cd5442h3e081adfb388e8f1@mail.gmail.com>
Subject: Re: [Bug #13948] ath5k broken after suspend-to-ram
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Stezenbach <js@sig21.net>,
       Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 7:01 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13948
> Subject         : ath5k broken after suspend-to-ram
> Submitter       : Johannes Stezenbach <js@sig21.net>
> Date            : 2009-08-07 21:51 (66 days old)
> References      : http://marc.info/?l=linux-kernel&m=124968192727854&w=4
> Handled-By      : Nick Kossifidis <mickflemm@gmail.com>
> Patch           : http://patchwork.kernel.org/patch/38550/

This patch was included in 2.6.31.2, so I believe this can go.

-- 
Bob Copeland %% www.bobcopeland.com
