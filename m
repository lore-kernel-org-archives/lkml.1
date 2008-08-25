Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYHYMQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYHYMQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYHYMQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:16:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:38515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYHYMQ1 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:16:27 -0400
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
From: David Woodhouse <dwmw2@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
References: <48AD00C4.6060302@gmail.com>
	 <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
	 <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 13:16:19 +0100
Message-Id: <1219666579.21254.0.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-22 at 09:51 -0700, Jared Hulbert wrote:
> Can you run mkfs.axfs on the same trivial directory on both ia32 and
> PPC64 and then get me the resulting images?

git.infradead.org is a big-endian box, and I know you have an account
there...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



