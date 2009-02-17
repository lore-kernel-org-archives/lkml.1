Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZBQSpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZBQSpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZBQSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:45:04 -0500
Received: from gw.goop.org ([64.81.55.164]:34998 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZBQSpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:45:03 -0500
Message-ID: <499B05A4.9020704@goop.org>
Date: Tue, 17 Feb 2009 10:44:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: jeremy@goop.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86: remove stale arch/x86/include/asm/page_64.h.rej
 file
References: <tip-ee8b53c1cfe33aecf0c77c0aa3ce437f0d84d831@kernel.org>
In-Reply-To: <tip-ee8b53c1cfe33aecf0c77c0aa3ce437f0d84d831@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Tue, 17 Feb 2009 12:20:13 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 17 Feb 2009 12:20:13 +0100
>
> x86: remove stale arch/x86/include/asm/page_64.h.rej file
>
> Introduced by:
>
>   51c78eb: x86: create _types.h counterparts for page*.h
>   

Oops, sorry about that.  Shouldn't *.rej and *.orig be in .gitignore?

    J
