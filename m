Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbZKFLig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbZKFLig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZKFLif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:38:35 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:48363 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZKFLie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vFpPGI8GiW3kFhhT0r2FPGzQoXhjt17hkIIOXjmn+GlhwrHmGPQn2uQdVez0yiVP1F
         oVqjVBJd/jtn2OS31NiHcDWm1mp9MpeuGm9G7CQtRaQimrmALD2O38e6xMYeAc66EbXM
         G1wF/L9YdZsNN9ICLg3mE6c8l4lGy7/aBYofY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
	 <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
Date: Fri, 6 Nov 2009 17:08:39 +0530
X-Google-Sender-Auth: 8ef71a6d5869dd59
Message-ID: <661de9470911060338q66746acbr219eedc24e752ca9@mail.gmail.com>
Subject: Re: mmotm 2009-11-01-10-01 uploaded
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 12:43 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 1 Nov 2009, akpm@linux-foundation.org wrote:
>
>> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>
> Does "soon" mean within this century ?
>
>>    git://git.zen-sources.org/zen/mmotm.git
>
> # git pull git://git.zen-sources.org/zen/mmotm.git master
> git.zen-sources.org[0: 216.98.141.250]: errno=Connection timed out
> git.zen-sources.org[0: 69.72.142.98]: errno=Connection refused
> fatal: unable to connect a socket (Connection refused)
>
I've seen that too, in fact I can't even reach the domain. I've pinged
the owner but not heard back yet.

Balbir
