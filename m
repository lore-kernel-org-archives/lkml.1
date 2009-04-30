Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbZD3PDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbZD3PDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZD3PDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:03:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33156 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZD3PDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:03:09 -0400
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Marc Pignat <Marc.Pignat@hevs.ch>,
       Roger Quadros <ext-roger.quadros@nokia.com>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0904301556310.2050@twin.jikos.cz>
References: <49F9C1AD020000BF00029086@mailgw2.hevs.ch>
	 <alpine.LRH.2.00.0904301556310.2050@twin.jikos.cz>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 08:03:03 -0700
Message-Id: <1241103783.3389.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > My bluetooth keyboard is not working any more in rc4, but was working in 
> > rc3.
> > Here is the dmesg output, triggered by the first key press on the 
> > keyboard, fortunately, this is 100% reproductible (once per boot).
> 
> Does reverting f3784d834c7 fix the problem?

we have seen a similar report where reverting f3784d834c7 didn't fix it.
And I don't see anything wrong with that patch. Did something important
got changed in the work queue code that I am missing?

Regards

Marcel


