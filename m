Return-Path: <linux-kernel-owner+w=401wt.eu-S2993463AbXEBQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993463AbXEBQUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993464AbXEBQUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:20:18 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54536
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993463AbXEBQUQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:20:16 -0400
Message-Id: <4638D66D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 02 May 2007 17:20:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <prarit@redhat.com>, "Haruo Tomita" <haruo.tomita@toshiba.co.jp>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fix the memory leak Intel RNG driver for
	2.6.21-rc7-mm1
References: <BF571719A4041A478005EF3F08EA6DF004332395@pcsmail03.pcs.pc.ome.toshiba.co.jp>
 <20070428001950.6c1fd98a.akpm@linux-foundation.org>
In-Reply-To: <20070428001950.6c1fd98a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Prarit, Jan: here's the original patch plus the two fixups.  Could you please
>re-review and ideally re-test this, let me know the result?

Works fine for me - ack. Jan

