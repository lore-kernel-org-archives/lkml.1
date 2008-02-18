Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYBRIw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYBRIw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYBRIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:52:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:63106 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYBRIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VLUhG3FCkmhWvNNF2ClO4Ej+MoOHy6h6UYjipxjWapEUFccseY5S+98QLhnAVyOheWZi4CqGxDrY1SKrJB6lL8lOz1YypK9CN0Xnodbqsmy11a7I15mVP24pc7eA5ebizns0Wx66h99qiZEwrLxCHwRWa02AQR5VQTqOSyw13bc=
Message-ID: <47B9473D.20508@gmail.com>
Date: Mon, 18 Feb 2008 09:52:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tilman Schmidt <tilman@imap.cc>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
References: <200802172304.00322.rjw@sisk.pl>
In-Reply-To: <200802172304.00322.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2008 11:03 PM, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10021
> Subject		: Linux 2.6.25-rc2 regression: LVM cannot find volume group
> Submitter	: Tilman Schmidt <tilman@imap.cc>
> Date		: 2008-02-16 20:14
> References	: http://lkml.org/lkml/2008/2/16/208
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>

NOTABUG, http://lkml.org/lkml/2008/2/17/386
