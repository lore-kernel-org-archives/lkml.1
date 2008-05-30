Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYE3Ehl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYE3Ehl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYE3Eh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:37:29 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46583 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752457AbYE3Eh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:37:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KTPRQieYRZaEKmt8UHHP2ZNIBST73lPcXgR3q/ELb3lDGFWJySNrWWaP+PaIph6+tb2w8u0jxcAC9LED1IG3E4fdhTK18ha6nn+EDML3/0roCOOItafuRf9KPjgYC1gwv7NPfU2g8UM/QmvCA7an7gXjyt8cSmU2Cu7HwQ8OvqE=  ;
X-YMail-OSG: ZUbCHB8VM1nz5XA1pMNuUbZ9nnfxHgv1vp054fu3t5GQmWdUFc9WTdU_yX0EQFNytOKtO.eorwTAu4OVXsBRuDQBA7FGN6zXryClEjywGGKo_qxNTqGB9c_FikJE1EeMnRM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: Latest gpio gumph
Date: Thu, 29 May 2008 20:18:49 -0700
User-Agent: KMail/1.9.9
Cc: Ben Nizette <bn@niasdigital.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
References: <1211942475.27810.37.camel@moss.renham> <200805280201.24256.david-b@pacbell.net> <20080528112109.47747cb5@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080528112109.47747cb5@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292018.50051.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Re that one avr32 patch: ]

On Wednesday 28 May 2008, Haavard Skinnemoen wrote:
> I'm not really opposed to the second change; I would have applied it if
> it came separately. But I think the first change is wrong.

OK, then feel free to strip out the first chunk and just take that.

- Dave

