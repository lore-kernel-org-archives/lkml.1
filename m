Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXFOTnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXFOTnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXFOTnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:43:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbXFOTnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:43:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: john.blackwood@ccur.com
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>, bugsy@ccur.com
Subject: Re: [RFC] [PATCH] selective signal ptracing
In-Reply-To: John Blackwood's message of  Friday, 15 June 2007 10:32:13 -0400 <4672A2ED.6030401@ccur.com>
X-Windows: warn your friends about it.
Message-Id: <20070615194229.AF0984D059F@magilla.localdomain>
Date: Fri, 15 Jun 2007 12:42:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not in favor of any enhancements to the ptrace interface.
It is a terrible interface and just needs to die.


Thanks,
Roland
