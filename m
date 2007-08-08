Return-Path: <linux-kernel-owner+w=401wt.eu-S937688AbXHHSr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937688AbXHHSr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761827AbXHHSru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:47:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52647 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762621AbXHHSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:47:49 -0400
Subject: [Documentation] Page Table Layout diagrams
From: Adam Litke <agl@us.ibm.com>
To: linux-mm <linux-mm@kvack.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "ADAM G. LITKE [imap]" <agl@us.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 08 Aug 2007 13:47:45 -0500
Message-Id: <1186598865.23817.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all.  In an effort to understand how the page tables are laid out
across various architectures I put together some diagrams.  I have
posted them on the linux-mm wiki: http://linux-mm.org/PageTableStructure
and I hope they will be useful to others.  

Just to make sure I am not spreading misinformation, could a few of you
experts take a quick look at the three diagrams I've got finished so far
and point out any errors I have made?  Thanks.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

