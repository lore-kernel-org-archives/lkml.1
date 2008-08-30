Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYH3TQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYH3TQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3TQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:16:15 -0400
Received: from cpsmtpo-eml04.kpnxchange.com ([213.75.38.153]:13226 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbYH3TQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:16:15 -0400
From: Frans Pop <elendil@planet.nl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Sat, 30 Aug 2008 21:16:06 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
References: <200808202106.41058.elendil@planet.nl> <200808202356.33036.rjw@sisk.pl> <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302116.07421.elendil@planet.nl>
X-OriginalArrivalTime: 30 Aug 2008 19:16:09.0659 (UTC) FILETIME=[DBF830B0:01C90AD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Maciej W. Rozycki wrote:
> On Wed, 20 Aug 2008, Rafael J. Wysocki wrote:
> > On my box I see many "APIC error on CPU1: 00(40)" messages that don't
> > seem to be related to anything obviously bad and I've alwas been
> > seeing them.
>
>  Barring a hardware erratum, this is a bug in the kernel.  It should be
> moderately easy to track down with some debugging added to writes
> accessing LVT and redirection table entries.

Could you please provide some more specific debugging instructions? I'm at 
a complete loss what I should do here.

I just re-read the rest of the thread, but I'm afraid most of it is Greek 
to me :-/

TIA,
FJP
