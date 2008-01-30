Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYA3AsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYA3AsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYA3AsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:48:12 -0500
Received: from web32403.mail.mud.yahoo.com ([68.142.207.196]:23692 "HELO
	web32403.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751919AbYA3AsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:48:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1DDVk531sPkGSpO02TNpDE894ksGv1M+5GJUXCYHZqAXDbD93urCQ41539ITPmnl+QKrOsaq8BedZvUWIwNjQX9Jx4z0QUhUABqJwtndEbzvEf85DnvjfxkD4x7RmpcmL/zllz/VKoy3byJEbbebUQ9rvAEt7l5+2nFEqRBX4sI=;
X-YMail-OSG: gYK29LIVM1lzsbgiCFSkR38wrfq1As1L3CFHnYom7zSHM1n_4vBMuqX1Pj_RMAd_kYn1i09UDLVXmwDm9UUwhdUhcgITevikx7cjzKuJC_eLQuvxFoyO_KTf5w--
Date: Tue, 29 Jan 2008 16:48:10 -0800 (PST)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
To: Adrian Bunk <bunk@kernel.org>, Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
In-Reply-To: <20080129225701.GS8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <754585.89171.qm@web32403.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Adrian Bunk <bunk@kernel.org> wrote:

> It is interesting that someone posting with an @gnu.org address claims
> that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> not a copyright violation.

There is no copyright violation: ndiswrapper is licensed under GPLv2. And the
Windows driver is not linked to kernel code - only ndiswrapper functions are
linked to kernel.

In case that is not clear, ndiswsrapper is an implementation of NDIS and some
Windows kernel API functions in Linux kernel. The Windows driver is linked to
these functions so the driver works as if it is working under Windows.

Giri


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

