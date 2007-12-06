Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbXLFVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbXLFVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXLFVvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:51:32 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:18598 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbXLFVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pWEAuHlkcu3FDLZ5PpLLBMLJBvS5IUwhbsEzwBXW5xqWKjTxXvuxlUcIE9hvAE5/a2aTFyZtiRgjMR/9OJ2zqBEKO9381wYoH4EZywDaYs0H0y5gR5CVsrzff/BLU3eo9a43NrRO4C90Py/r5QmB4mm1hWRCk0JRRZbvzP/Frmw=
Message-ID: <47586F67.8020101@gmail.com>
Date: Thu, 06 Dec 2007 22:53:43 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Holger.Wolf@de.ibm.com, wolf@linux.vnet.ibm.com, mingo@elte.hu,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Scheduler behaviour
References: <475706E2.50805@linux.vnet.ibm.com> <20071205132631.79940bd5@laptopd505.fenrus.org>
In-Reply-To: <20071205132631.79940bd5@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote, On 12/05/2007 10:26 PM:

> On Wed, 05 Dec 2007 21:15:30 +0100
> Holger Wolf <wolf@linux.vnet.ibm.com> wrote:

...

>> a 2.6.23 kernel. We saw a throughput degradation from 7.2 to 23.4
> 
> this is good news!
> dbench rewards unfair behavior... so higher dbench usually means a
> worse kernel ;)


Yes!!!

(But, with those new patches, I guess, our kernel will be worse enough?!)

Jarek P.
