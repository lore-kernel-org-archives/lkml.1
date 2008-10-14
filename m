Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYJNGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYJNGnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYJNGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:43:14 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:44024 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYJNGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:43:14 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: benh@kernel.crashing.org
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks
Date: Tue, 14 Oct 2008 08:42:31 +0200
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200806031444.21945.borntraeger@de.ibm.com> <200810130951.31733.borntraeger@de.ibm.com> <1223944714.8157.300.camel@pasglop>
In-Reply-To: <1223944714.8157.300.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810140842.31806.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Oktober 2008 schrieb Benjamin Herrenschmidt:
> 
> > Hmmm. 
> > Can you try if this patch fixes the lockdep trace?
> 
> Yup, the patch fixes it, I'll commit it via the powerpc.git tree if you
> don't have any objection.

Sure, go ahead.
