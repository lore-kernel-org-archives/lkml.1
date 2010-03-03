Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0CCSzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:55:16 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56256 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0CCSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:55:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QbhRS9CF5DOWbQGEiMEYtUYM25RlI9eelQJuRa1JJRLWrm0A4B86thzp43FRqZtWbH
         cdIS7wFCjJV3wZ5ILY9aA2GbhLUDdNjHZPtgN4X5ZVYxIqgJra8a3RmkDXD8GKxC6ULt
         41yA2Drw9vnpsNhzgp7CWoKpIPVYB2cZZynEc=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-02 - kernel BUG at fs/direct-io.c:630
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
	<10679.1267639769@localhost>
Date: Wed, 03 Mar 2010 21:55:10 +0300
In-Reply-To: <10679.1267639769@localhost> (Valdis Kletnieks's message of "Wed,
	03 Mar 2010 13:09:29 -0500")
Message-ID: <87pr3lkzg1.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Tue, 02 Mar 2010 18:39:07 PST, akpm@linux-foundation.org said:
>> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
>> 
>>    http://userweb.kernel.org/~akpm/mmotm/
>
> This goes kersplat at boot for me. x86_64 on a Dell Latitude E6500.
http://bugzilla.kernel.org/show_bug.cgi?id=15424
already fixed.
