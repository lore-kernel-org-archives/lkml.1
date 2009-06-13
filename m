Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZFMHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZFMHDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZFMHDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:03:39 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3077 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFMHDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:03:39 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'Ingo Molnar'" <mingo@elte.hu>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>
cc: "David Miller" <davem@davemloft.net>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Date: Sat, 13 Jun 2009 00:03:28 -0700
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
Thread-Topic: -git tree build failure in drivers/net/cnic.c: undefined
 reference to `ip6_route_output'
Thread-Index: Acnr8jjuLP19696SQ2GhavJ+oNy8bwACjW7w
Message-ID: <C27F8246C663564A84BB7AB343977242178EE78066@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20090613064253.GB14034@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 662D90CA38G4198754-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> The thing is, this driver has been submitted 4 days ago, merged by
> you 3 days ago and sent upstream two days ago. It has two build
> breakages so far, the first one of which triggered on a pretty
> common config too.
>

Sorry for all the troubles.  The final version was submitted 4 days
ago after many iterations.  This is actually the 3rd build error so
far.  Hopefully, it's the last one.  Thanks everyone.

