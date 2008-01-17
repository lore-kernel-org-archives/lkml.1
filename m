Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYAQAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYAQAeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYAQAdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:33:43 -0500
Received: from n6b.bullet.ukl.yahoo.com ([217.146.182.216]:20901 "HELO
	n6b.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754183AbYAQAdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:33:42 -0500
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 440284.75486.bm@omp207.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nc4MtPsPFCBn1nrLUVWLsun2Z10nhCMRrbXPC+Vx+27oC7EWMOA3DRkwHfDdgf6mIbVWJdI7XQo0GfhEHbBMJPCJh9Kj64cHe9yo3tDdEIYcttJDtYB4RdcZaGdtsI6/TCoYbTEYm9Lv5Y++q/oPLZXcCQDfwuZdZPbfvVDPArg=;
X-YMail-OSG: AlESgPQVM1kUIV6w5fuZaiser2ju1xPOAF9ELPMb
Date: Wed, 16 Jan 2008 16:33:39 -0800 (PST)
From: Sebastian Manciulea <manciuleas@yahoo.com>
Subject: patch with support for UDF 2.50 (read-only)
To: linux-kernel@vger.kernel.org
Cc: axboe@suse.de, psusi@cfl.rr.com, jack@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <186027.56226.qm@web43144.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To whom it may concern,

More the a year ago me and my colleague posted a patch
on  the Linux UDF site
(http://sourceforge.net/projects/linux-udf/) which
adds support to Linux for reading UDF 2.50 formatted
media. In time I've updated the patches for the newer
kernel versions and did some bug-fixing. The patch has
been tested over time with various types of media
(BD-ROM, BD-RE, BD-R, DVD, CD) and it looks pretty
stable.
I wonder if someone can take a look at the patch and
let me know if it's ready for inclusion into the
mainline kernel, or at least direct me to the
appropriate sub-system maintainer.
Thank you.

Regards,
Sebastian Manciulea



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

