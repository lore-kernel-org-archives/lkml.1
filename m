Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXERLrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXERLrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXERLrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:47:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:50827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893AbXERLrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:47:45 -0400
From: Andi Kleen <ak@suse.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Date: Fri, 18 May 2007 13:47:13 +0200
User-Agent: KMail/1.9.1
Cc: Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705181347.14256.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I do not see such on i386, so why for x86_64?

So that you know that one of your programs crashed. That's a feature.

-Andi
