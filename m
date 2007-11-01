Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXKAMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXKAMmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXKAMmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:42:11 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:25672 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754068AbXKAMmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:42:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MkomtoUA1bkFOrYiXB7TUaAEVwUEwqFgj1Cwu1ZVdIXnSwr86qRYNYHFu5GoOreWkDiUlEo8ZOsND7fxDPswbXDQpIc0AGFdjyTDYxvUFPj5UBuHZQsw8Vf9ynv/hj1ORWUcnI8f8ik9Nuo5wJT4/Ll1VtkH9bpIBQ4M7RsHPxA=  ;
X-YMail-OSG: QUp28E8VM1nc3R0LYdVOzE53rM5hnRPdAicuQLFRlpHEEG4dSXwHOtxbXrt16jYX5Zy0zaNviPlOVFn0acnwIskGVbt9cWb0iZg2VmnZGpSBR0zkK2U-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Date: Thu, 1 Nov 2007 22:35:26 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <1193918202.8439.7.camel@rukbat>
In-Reply-To: <1193918202.8439.7.camel@rukbat>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012235.26757.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 22:56, Romano Giannetti wrote:
> Hi,
>
> 	I have a very possible regression to signal. This morning 2.6.24-rc1
> eat and destroyed my SD card. I have a toshiba laptop with a card slot
> and I have used it with 2.6.23-rcX and 2.6.23 without problems so far.
> This morning I put the card in, nothing happened, removed it. When I put
> it in again the filesystem in it was completely scr***ed up.
>
> I have a flight waiting now, so I have put all the dmesgs and syslogs
> over there:
>
> http://www.dea.icai.upcomillas.es/romano/linux/info/2624-rc1-mmc/
>
> Sunday I'll be back to help debug it.

Thanks for the report. Is it a FAT filesystem? Is it reproduceable?
