Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYIRSSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYIRSSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbYIRSRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:17:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYIRSRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:17:51 -0400
Message-ID: <48D29AFB.5070409@linux-foundation.org>
Date: Thu, 18 Sep 2008 13:16:27 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Snook <csnook@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com> <48D17A93.4000803@goop.org>
In-Reply-To: <48D17A93.4000803@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a patch like that a couple of years back but it was not accepted.

http://www.kernel.org/pub/linux/kernel/people/christoph/prefault/

http://readlist.com/lists/vger.kernel.org/linux-kernel/14/70942.html

http://www.ussg.iu.edu/hypermail/linux/kernel/0503.1/1292.html


