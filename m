Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZBDUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZBDUBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZBDUAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:00:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:41712 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZBDUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:00:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TrcCPipquzysuEGr7FXAko7ZtYePOULOoyesfppm8hPdO+NfRyKkEx4IigqrUuuSmn
         v0xupMFliwLPyzBtXav5pKIGRMoWf7BPY123wIdiYA5NOk6RZoWGjZpY1YrzmyBzNz6r
         inJOdhem+dBQ4lkTOKTj3k45CpeLao7ZoPlYA=
MIME-Version: 1.0
In-Reply-To: <9ae48b020902040937q15d8c158s86fbc358d03ee0ef@mail.gmail.com>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <4989CB58.5000509@myri.com>
	 <9ae48b020902040937q15d8c158s86fbc358d03ee0ef@mail.gmail.com>
Date: Wed, 4 Feb 2009 12:00:43 -0800
X-Google-Sender-Auth: 9d401b48f0278d4d
Message-ID: <86802c440902041200k402699b7ibd2f7664cc59b509@mail.gmail.com>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
From: Yinghai Lu <yinghai@kernel.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: Loic Prylli <loic@myri.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 9:37 AM, Ed Swierk <eswierk@aristanetworks.com> wrote:
> On Wed, Feb 4, 2009 at 9:07 AM, Loic Prylli <loic@myri.com> wrote:
>> Minor question: there are motherboards with two MCP55 southbridges. Would
>> the patch support mmconfig for both?
>
> Can you point me to such a motherboard? I have only seen boards with
> one MCP55 plus a C51 companion chip providing extra PCIe lanes.
>
nvidia CRB

YH
