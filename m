Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbXLTL7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbXLTL7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbXLTL7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:59:30 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:33955 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbXLTL72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q7EGfmXT+EA+gSFDwn1v88Q/9tzqkalOgUzL3f7h8ZwtNIp71YYujPL7PbmU9lPWZiOfVENlnqKvqlsHEHXAA/FPqhox594rzOyIcctLb+TYIW8o2XMvnbaxdrq/ODVPmctu2Nl7ZbPRc3uoyyTEr1kFZRQkPoDIWER3NLBXbnI=
Message-ID: <1985e0f60712200359k6194b0fdn25ead9b5c0835c95@mail.gmail.com>
Date: Thu, 20 Dec 2007 17:29:27 +0530
From: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
To: "Remy Bohmer" <linux@bohmer.net>
Subject: Re: [patch 3/3] Enable setting of IRQ-thread priorities from kernel cmdline. (repost:CC to LKML)
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Juergen Beisert" <jbe@pengutronix.de>,
       "Darren Hart" <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47697888.143f420a.5466.ffff89ba@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219194551.315868746@bohmer.net>
	 <47697888.143f420a.5466.ffff89ba@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/07, Remy Bohmer <linux@bohmer.net> wrote:
> The RT-patch originally creates all its softirq-threads at
> priority 50.

Is it possible to run softirq-threads or IRQs as a non-realtime tasks
in RT kernel.

If yes, then how.

Thank you,

Jaswinder Singh.
