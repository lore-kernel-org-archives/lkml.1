Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYCYXcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYCYXcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbYCYXco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:32:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYCYXcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:32:43 -0400
Date: Tue, 25 Mar 2008 16:32:40 -0700 (PDT)
Message-Id: <20080325.163240.102401706.davem@davemloft.net>
To: paulus@samba.org
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <18408.59112.945786.488350@cargo.ozlabs.ibm.com>
References: <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
	<20080324.211532.33163290.davem@davemloft.net>
	<18408.59112.945786.488350@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Tue, 25 Mar 2008 22:50:00 +1100

> How do I get gcc to use hugepages, for instance?

Implementing transparent automatic usage of hugepages has been
discussed many times, it's definitely doable and other OSs have
implemented this for years.

This is what I was implying.
