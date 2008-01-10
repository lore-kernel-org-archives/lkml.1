Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYAJSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYAJSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbYAJSo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:44:26 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:42713 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbYAJSoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:44:25 -0500
Date: Thu, 10 Jan 2008 20:44:23 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Hellwig <hch@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Dave Airlie <airlied@gmail.com>, jbeulich@novell.com
Subject: Re: Replacement for page fault notifiers?
Message-ID: <20080110204423.31915fb7@daedalus.pq.iki.fi>
In-Reply-To: <20080109202254.GA5279@infradead.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	<20080108203235.GA772@infradead.org>
	<21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	<1199838407.6734.83.camel@pasglop>
	<1199902724.8050.11.camel@dv>
	<20080109182157.GA32754@infradead.org>
	<1199908703.6734.133.camel@pasglop>
	<20080109202254.GA5279@infradead.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 20:22:54 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> Please submit the mmiotrace for 2.6.25 and we'll find some way to make
> it work.

Fair enough. Thanks to all for the encouraging words. I will start to
work towards sending mmio-trace to kernel.

We'll see how far I get before 2.6.25 closes. I'm new to all this and
will need help, especially in making mmio-trace SMP-safe, for instance.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
