Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYA3SBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYA3SBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYA3SBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:01:42 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:36250 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbYA3SBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:01:41 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 13:01:41 EST
X-Authority-Analysis: v=1.0 c=1 a=EouV8EeEjs0A:10 a=RXvFtDA4TIRRQeNwqcoA:9
 a=cYd9i9LoYStH_cM11VfqqIzvLNwA:4 a=BgJWR2bEJjkA:10
Subject: Re: [BUILD FAILURE] 2.6.24-git7 section type conflict at various
	drivers on powerpc
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 11:57:31 -0600
Message-Id: <1201715851.7154.15.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please note that this does not appear to be just a issue with the
powerpc build - I get the following failure whiole building a generic
x86 2.6.24-git7 kernel.

drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type
conflict

I suspect that you are ahead of me and alrealy knew this but I get into
trouble every time I make an assumption like that.

Chris

