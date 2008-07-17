Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYGQSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYGQSJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYGQSJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:09:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYGQSJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:09:05 -0400
Subject: Re: madvise(2) MADV_SEQUENTIAL behavior
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Snook <csnook@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Rannaud <eric.rannaud@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <487F89AE.9070007@redhat.com>
References: <1216163022.3443.156.camel@zenigma>
	 <487E628A.3050207@redhat.com>	<1216252910.3443.247.camel@zenigma>
	 <200807171614.29594.nickpiggin@yahoo.com.au>
	 <20080717102148.6bc52e94@cuia.bos.redhat.com> <487F89AE.9070007@redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 20:09:31 +0200
Message-Id: <1216318171.5232.98.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry can't resist...

On Thu, 2008-07-17 at 14:04 -0400, Chris Snook wrote:

> 1) start up a memory-hogging Java app

Is there any other kind? :-)


