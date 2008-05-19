Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbYESRVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbYESRVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYESRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:21:34 -0400
Received: from visualserver.org ([84.242.66.126]:39809 "EHLO visualserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYESRVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:21:33 -0400
Date: Mon, 19 May 2008 19:21:27 +0200 (CEST)
From: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
To: linux-kernel@vger.kernel.org
cc: akinobu.mita@gmail.com
Subject: significance of using 2kb long byte_rev_table in lib/bitrev.c
Message-ID: <Pine.LNX.4.64.0805191918440.18755@visualserver.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-visualserver.org-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: BF6E42FB42.AD4C4
X-visualserver.org-MailScanner: Found to be clean
X-visualserver.org-MailScanner-From: kernelhacker@visualserver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
 	i cant understand the significance of using 2kb size of
bit_rev_table array in lib/bitrev.c
I guess it has something to do with bit reversal of a 32 bit word.
Well it can be done smoothly without using such a long sized array.
I am sending patches regarding this in the following mails.
Please review them.
Thanks :-)

Soumyadip

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

