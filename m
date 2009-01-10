Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZAJBMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZAJBMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbZAJBMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:12:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38607
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZAJBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:12:01 -0500
Date: Fri, 09 Jan 2009 17:12:01 -0800 (PST)
Message-Id: <20090109.171201.80737529.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, a.beregalov@gmail.com
Subject: Re: + irda-fix-incomplete-conversation-to-internal-stats.patch
 added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901100023.n0A0N9st031030@imap1.linux-foundation.org>
References: <200901100023.n0A0N9st031030@imap1.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Fri, 09 Jan 2009 16:23:09 -0800

> Subject: irda: fix incomplete conversation to internal stats
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> Fix for commit af0490810c (irda: convert to internal stats)
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, this is already in the net-2.6 GIT tree, so you can safely
toss this.

commit 35a2f9993e1bef0d09c3d737aef784caaa888b48
Author: Alexander Beregalov <a.beregalov@gmail.com>
Date:   Thu Jan 8 16:42:08 2009 -0800

    irda: fix incomplete conversation to internal stats
    
    Fix for commit af0490810c (irda: convert to internal stats)
    
    Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
