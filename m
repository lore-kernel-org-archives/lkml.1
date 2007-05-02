Return-Path: <linux-kernel-owner+w=401wt.eu-S1766756AbXEBQv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766756AbXEBQv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766758AbXEBQv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:51:29 -0400
Received: from mail.suse.de ([195.135.220.2]:45582 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766756AbXEBQv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:51:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Bill Irwin <bill.irwin@oracle.com>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Date: Wed, 2 May 2007 18:51:13 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Kruchinin <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, wli@holomorphy.com
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com> <4638BC3E.9080708@goop.org> <20070502163244.GA26598@holomorphy.com>
In-Reply-To: <20070502163244.GA26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021851.13322.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It needs verification with the testcase from this thread.

Verified. Bug is fixed.


-Andi
