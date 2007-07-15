Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXGOQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXGOQmo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbXGOQmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:42:36 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:47570 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758197AbXGOQmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:42:35 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=kiGxiCupyeQ17tr7/SSMdJV2I0GBZStmMAgawfBN5yYN/cKXg+NcSOCk/A6d0mpXXq1JXIG41lZFvSxT6qHXUA==  ;
Date: Mon, 16 Jul 2007 01:41:15 +0900 (JST)
Message-Id: <20070716.014115.193701589.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: i386: pata_cs5520 does not work
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 5.1 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I update to 2.6.22.1 from 2.6.21.5. And PC cannot mount /.
It seems pata_cs5520 does not find IDE controller.
(I don't have serial cable for CS5520 board now. I cannt read
boot messages.)
2.6.21 is OK.
In 2.6.22, IDE driver is OK.
Is any information necessary?
