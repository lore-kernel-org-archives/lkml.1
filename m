Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYBYIlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYBYIlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYBYIlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:41:03 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:64826 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYBYIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wk3K7jtzEt3rmjP1MTEBb/PnGZGOtIeZdIZozs+YJXiw8Y+wT3TmwtaTOigCAAR4x2OBbEm7LqGqFaA15AizDe2zaGhHENliHaFsNS/MzKvHx3sR1X3i6JmVf8b9pkOZtLMu+I7m019wPJxCozN1aUQGd7ZUsPHHUPAOPylpkaU=
Message-ID: <4d8e3fd30802250040ie77dbecw6cc396a0f2a9285e@mail.gmail.com>
Date: Mon, 25 Feb 2008 09:40:59 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] IDE: Coding Style fixes to drivers/ide/pci/cy82c693.c
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080225073122.GE11327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224221144.1e9e7449@paolo-desktop>
	 <20080225073122.GE11327@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 8:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
>  > Before:
>  > total: 34 errors, 14 warnings, 456 lines checked
>  >
>  > After:
>  > total: 0 errors, 8 warnings, 456 lines checked
>
>  sidenote: please also indicate to maintainers that the cleanup causes no
>  change in generated code. Find below of how one of your cleanup patches
>  looks like in its final form in x86.git. (i auto-generated all of the
>  commit log)
>
>  info like that makes it easier for maintainers to see the intended zero
>  impact of your changes.

Sure, I'll script that.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
