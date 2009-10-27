Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZJ0VZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZJ0VZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJ0VZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:25:33 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47130 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbZJ0VZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dId3Qwttwf/PsVTk5sMNawmrFpo2lGcCt3MvU5BcE5bpf9O32uTAMSd9nE/Z6KSuG2
         MKikEHfUSO/C3n9WA7sWWEHKRX9swMhlT8qVOSs6XiLp7oqzEF8HaQQ/1qcJTHZZql0y
         AW7UqwP97jdUNwAF/XPsW/egbSKiR7WjkM2x0=
Message-ID: <4AE7654B.6040401@gmail.com>
Date: Tue, 27 Oct 2009 22:25:31 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #14484] no video output after suspend
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.5tE.0qe5KB@chimera>
In-Reply-To: <6dRYo8ss7vL.A.5tE.0qe5KB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

Rafael J. Wysocki ha scritto:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14484
> Subject		: no video output after suspend
> Submitter	: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
> Date		: 2009-10-25 20:57 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=125650430123713&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>

Since the bad commit is around 2.6.31-rc9 i think this is a regression 
from 2.6.30 and not 2.6.31, it's me that have reported the issue so 
late. Then the patch that you added on the first comment is for another 
issue and not this one.

thanks,
riccardo
