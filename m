Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbYJSSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbYJSSeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYJSSeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:34:13 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:26690 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751533AbYJSSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:34:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=okYKhQr4dk57B0hpBBvBSZevsdu1k3FO+emzQB8H1rwj5oo7QVcqem5gGEc7aL6TvCyid6UZ+t3gV+DDmwhGn85TX8vJIRqmMygBQSgcdHnqoJKDWVkEFJaaWN00eFts5mXgf+ZLNZGDayAl0pgQguLwQHRKBwnVxyrUGUL9G4Q=  ;
X-YMail-OSG: GYCWTzgVM1nAYD6J8SMMdinpAQXtee032w7apWErk_6gY4KaBfZGpjUFisAD3Mcn2SkaFwKSBoGa4AuUkIeZcOmAw77TsDoSSEBPc96PII_MIkvgJRXWZ7C8bKorLEktKaU7pn.5dSifSYWY7Kk5EbArv5k9KcuO6TdyCezVuZRV70ke_DBIhGG4Ao7x
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [patch 2.6.27-rc8-git] add drivers/mfd/twl4030-core.c
Date: Sun, 19 Oct 2008 11:34:08 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
References: <200810061047.50127.david-b@pacbell.net>
In-Reply-To: <200810061047.50127.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810191134.09204.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008, David Brownell wrote:
> This patch adds the core of the TWL4030 driver, which supports
> chips including the TPS65950.  These chips are multi-function; see 
> 
>   http://focus.ti.com/docs/prod/folders/print/tps65950.html
> 
> Public specs are in the works.

... and are now available at that URL:  all 925 pages (!!) of
technical reference manual, for your reading pleasure.

I understand that the tps65950 is more or less equivalent to
the twl5030, which is the latest incarnation of the twl4030.

- Dave

