Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYC1WJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYC1WJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYC1WJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:09:27 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:32607 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757598AbYC1WJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:09:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vuLKCk2iO1EvwyMihO/Oh96zYPX/jAsu2nTpNw4eSHETKDq94UKikWBqLHE6LUnFIIFkaOPv+UgAdHLzYHhX8sgNtWGyAMc5hJ0Ac+/5OOd6Qz+mSpwCx3ez9LnURUo/U1OQNLlnFJmmiVpSazQvuC0Qqthc0kdno1wMNnp86bY=  ;
X-YMail-OSG: FZL3mTMVM1lPuPvDLfciP_QCg8yVv1UgN7rufx.LOp5QEE65zhGi95U7lxT3.ZvH3auuvigPNg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 15:09:22 -0700
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281409.09622.david-b@pacbell.net> <924EFEDD5F540B4284297C4DC59F3DEEC83E08@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEC83E08@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281509.23107.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Pallipadi, Venkatesh wrote:
> You should have a dmesg line which looks like
> ACPI: CPU0 (power states: C1[C1] C2[C2]
> Do you see C2 in such line?

Yes:

ACPI: CPU0 (power states: C1[C1] C2[C2])



