Return-Path: <linux-kernel-owner+w=401wt.eu-S1751077AbZFVEA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbZFVEA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 00:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbZFVEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 00:00:12 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:23691 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZFVEAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 00:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i/gUJt6hpyMfA7c48NJ529iQ/dTZkehvd/vnu5hH9p+wsxrWrpgLCBZZtjgw672Khq
         /WrYOnVJi8bh4LKfGlQN+QM0T3sEER4Ethg5al/1ojnsMIpzNMgDYxqneP2+po91iB3a
         9B6FqyXkW9yM0uYwTyVPTFDTQoJ7fHh9shOtA=
MIME-Version: 1.0
In-Reply-To: <20090621.161343.181101055.davem@davemloft.net>
References: <20090621.141950.160759111.davem@davemloft.net>
	 <200906220034.22430.bzolnier@gmail.com>
	 <20090621.155756.100422570.davem@davemloft.net>
	 <20090621.161343.181101055.davem@davemloft.net>
Date: Sun, 21 Jun 2009 23:39:04 -0400
Message-ID: <87f94c370906212039sa23d49fh305d8f0d58a48d1f@mail.gmail.com>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system 
	is dreadfully slow)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm going to treat IDE as pure legacy, rather than as competition
> with the PATA drivers which is what people whould be moving over to.

> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

What impact does that on Linux and its growing popularity in arm
platforms?  I had assumed that most arm platforms were long term users
of drivers/ide, but I have no facts to back that up.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
