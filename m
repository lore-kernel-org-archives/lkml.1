Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYCZAIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYCZAIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYCZAI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:08:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYCZAI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:08:27 -0400
Date: Tue, 25 Mar 2008 20:08:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jack Steiner <steiner@sgi.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/8] x86_64: Add UV specific header for MMR definitions
Message-ID: <20080326000820.GA18701@infradead.org>
References: <20080324182116.GA28285@sgi.com> <20080325082756.GA6589@infradead.org> <87myoni0gp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87myoni0gp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 11:04:22AM +0100, Andi Kleen wrote:
> bitfields are only problematic on portable code, which this isn't.

it's still crappy to read and a bad example for others.  And last time
I heard about UV it also included an ia64 version, but that's been
loooong ago.

