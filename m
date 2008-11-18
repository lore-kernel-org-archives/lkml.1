Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbYKRMu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbYKRMu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYKRMuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:50:50 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:16042 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYKRMut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:50:49 -0500
Message-Id: <4922C863.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Nov 2008 12:51:31 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <heukelum@fastmail.fm>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com>
 <20081118111633.GA21036@mailshack.com>
In-Reply-To: <20081118111633.GA21036@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alexander van Heukelum <heukelum@mailshack.com> 18.11.08 12:16 >>>
>> >Dwarf2-annotations are most probably wrong or missing at all.
>> 
>> Indeed - do you have intentions to address this?
>
>Yes, I'ld like to get it right. What do you use to check the
>annotations?

No tool, if you mean that. Extensive changes I verify by looking at the
dump, problems are usually found only when back traces don't come out
right.

Jan

