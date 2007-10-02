Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXJCIiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXJCIiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXJCIiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:38:17 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43472 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751301AbXJCIiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:38:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rfzT+TA60g9WPTLeNKeVapycfFVeDmVLnp5yh312jlKPigQLazbnPNhMJ1h+R+qjv/WUX2pMOWbEbvC0obZIqETPJHtAbzs+JMkjZ4reaQOMn5XM/3aUUQJnw7Uk2NGp4ahr/3NwIznCslGqWz8+PI3hAgV0o4kMG3XslVgVrVg=  ;
X-YMail-OSG: cBwb.uQVM1knIpCJWgBzMeCxdEw160HibIvQeaLc5apZF82C
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Date: Wed, 3 Oct 2007 01:46:29 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <20071003062240.GA19027@elte.hu> <20071002235615.6e8cd007.pj@sgi.com>
In-Reply-To: <20071002235615.6e8cd007.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030146.30162.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 16:56, Paul Jackson wrote:

> I must NAQ this patch, and I'm surprised to see Nick propose it
> again, as I thought he had already agreed that it didn't suffice.

Sorry for the confusion: I only meant the sched.c part of that
patch, not the full thing.
