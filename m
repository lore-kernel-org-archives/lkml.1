Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYFROCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYFROCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYFROCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:02:31 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:35406 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752819AbYFROCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:02:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TCN7iTLhhYxXAy3x65650rKMoGqiddHsIWBQ4s/fX5L85IEQ5RmJLzWuZZAA0O+S4q+7DXBaktswy56eGzOb6Hjn59Ux8cC4BMBt3mBgJ7b5MMwuu0jDA5SUj8Nf26+PnbsNXO6cN9rHXgQ9IyvhBARa8JgqUtpsTriXFGv+fps=  ;
X-YMail-OSG: fDRpne0VM1ni5kWgvx9bYVPMT5HnI_n1u6E9VyA9Q49HKCdFBp_cixNxcwIdkWPb7vO3LpSeifPVMkHqhz1Wg8ExXMZ_YcdUu.qmbFblDA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] MM: virtual address debug
Date: Thu, 19 Jun 2008 00:01:49 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com> <200806182251.02486.nickpiggin@yahoo.com.au> <485910A0.1060007@gmail.com>
In-Reply-To: <485910A0.1060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190001.50224.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 23:41, Jiri Slaby wrote:

> Thanks for comments, well, are you OK with __phys_addr being a function
> only on CONFIG_VIRTUAL_DEBUG?

Yes

