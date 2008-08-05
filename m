Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYHEFJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYHEFJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYHEFJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:09:15 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:41431 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753817AbYHEFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:09:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dsJBl7GDfocwOwpuQ9RiwkZWuEUQ99xd6jbnpP08UcW/hQaOmmGCPHMbzxvpZGYMSMh5dP20keiVxUoDFW5h+A1RLbZySp5dH1s5m9giKVXki2NMi/GoP+/bOqH7Cdv+l3mkhSbVqI8xXTcNTefuk7L9kWwc6FSGflRpeTrJ6KQ=  ;
X-YMail-OSG: Ch_zrBEVM1nLD5Bkkg3OJOFGLf2aPip1j2gmtDGhushnC..RTiS6efGyJfbRGWz4QtRem_pHPy9pgxGdoSHgMt6d2b798jTgcRV.V.277A8JInG6putV7lysvsOE_gy_8oA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 15:09:06 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051444.19738.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808042157020.3299@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808042157020.3299@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051509.07034.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 14:57, Linus Torvalds wrote:
> On Tue, 5 Aug 2008, Nick Piggin wrote:
> > Buffer trylock too? Pretty please ;)
>
> Now you're just pushing your luck.
>
> But yeah, I took that one too.

You're a gem. Thanks!
