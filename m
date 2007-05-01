Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXEADpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXEADpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030521AbXEADpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:45:32 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbXEADpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:45:03 -0400
Message-ID: <4636B7B4.7040201@zytor.com>
Date: Mon, 30 Apr 2007 20:44:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <20070501015115.GJ26601@redhat.com>	<4636A332.2070101@zytor.com>	<m1odl51dci.fsf@ebiederm.dsl.xmission.com>	<20070501034612.GK25929@bingen.suse.de>	<m1hcqx1bvg.fsf@ebiederm.dsl.xmission.com>	<4636B227.2020403@zytor.com> <m1d51l1a8m.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d51l1a8m.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I would be very surprised if the high volume commodity boards have
> exceeded 8 megabits.
> 

Most of the high-capacity chips are used on laptops, not conventional
motherboards.

	-hpa
