Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbYCYNpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbYCYNpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYCYNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:45:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37113 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754740AbYCYNpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:45:03 -0400
Date: Tue, 25 Mar 2008 08:45:00 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/8] x86_64: Add UV specific header for MMR definitions
Message-ID: <20080325134459.GA19668@sgi.com>
References: <20080324182116.GA28285@sgi.com> <87iqzbi0cy.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqzbi0cy.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:06:37AM +0100, Andi Kleen wrote:
> Jack Steiner <steiner@sgi.com> writes:
> 
> > 
> > 	Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> Not sure why you indent that? Normally it is not. 
> Some tools get confused by it I think.

Fixed.


> 
> > ---
> >  include/asm-x86/uv_mmrs.h |  373 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 373 insertions(+)
> > 
> > Index: linux/include/asm-x86/uv_mmrs.h
> 
> I personally would consider it cleaner to put these into a asm-x86/uv/ 
> sub directory

Will change...


--- jack
