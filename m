Return-Path: <linux-kernel-owner+w=401wt.eu-S935535AbXJSTWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935535AbXJSTWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763445AbXJSTW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:22:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:52050 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760406AbXJSTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:22:25 -0400
Date: Fri, 19 Oct 2007 15:22:24 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Intel PCI-e x1 1Gbps NIC support in 2.6.23?
Message-ID: <Pine.LNX.4.64.0710191521140.15251@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.tigerdirect.com/applications/searchtools/item-details.asp?EdpNo=2276643&body=REVIEWS#tabs

REVIEW BY: tesseract Reviewed  Jun 26, 2007
Due to a bug in the hardware of this card it doesn't work with Linux. The 
card does works at 100mb/s speed but when put to gigabit speeds it gets TX 
Unit Hang messages. Further information can be found at 
http://e1000.sourceforge.net/wiki/index.php/Issues . The drivers haven't 
be able to work around the issue yet, its been over a year. Just as a side 
note, I don't know the quality of card in windows as I don't run windows.

http://e1000.sourceforge.net/wiki/index.php/Issues

Has this issue been resolved / will this board now work in 2.6.23, is 
anyone on this list running these boards successfully?

Justin.
