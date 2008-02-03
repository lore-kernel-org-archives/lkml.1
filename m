Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbYBCLNr (ORCPT <rfc822;ralf@linux-mips.org>);
	Sun, 3 Feb 2008 06:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYBCLNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:13:36 -0500
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181]:47741 "HELO
	n4.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753444AbYBCLNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:13:35 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 818542.49196.bm@omp404.mail.sp1.yahoo.com
X-YMail-OSG: .ClN14IVM1lbkTbRRHrsaLRE5zQasrMpGAHoDE_52KCuT3G3_8o.jrcTLKbO6gaG9Apse6MFIoon.dgNnuOSJzRHbQ--
Date: Sun, 3 Feb 2008 03:13:33 -0800 (PST)
From: am kara <kara_am@yahoo.com>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <642794.12747.qm@web45910.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Return-Path: <linux-kernel-owner+ralf=40linux-mips.org-S1762301AbYBCLNr@vger.kernel.org>

hello,

If kernel does kmap_atomic(temporary kernel mapping)
on behalf of a process by a cpu, does the process will
continue to run and no other process can be scheduled
to switch it off?(till kunmap_atomic is done)

 


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

