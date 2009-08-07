Return-Path: <linux-kernel-owner+w=401wt.eu-S933246AbZHGTrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbZHGTrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbZHGTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:47:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:14998 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbZHGTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:47:44 -0400
From: "Paul Congdon \(UC Davis\)" <ptcongdon@ucdavis.edu>
To: "'Stephen Hemminger'" <shemminger@vyatta.com>
Cc: <drobbins@funtoo.org>, "'Fischer, Anna'" <anna.fischer@hp.com>,
       "'Arnd Bergmann'" <arnd@arndb.de>, <herbert@gondor.apana.org.au>,
       <mst@redhat.com>, <netdev@vger.kernel.org>,
       <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <ogerlitz@voltaire.com>, <evb@yahoogroups.com>, <davem@davemloft.net>
References: <0199E0D51A61344794750DC57738F58E6D6A6CD7F6@GVW1118EXC.americas.hpqcorp.net>	<004f01ca1792$b24a7a90$16df6fb0$@edu> <20090807123554.7c2bc27c@nehalam>
In-Reply-To: <20090807123554.7c2bc27c@nehalam>
Subject: RE: [Bridge] [PATCH] macvlan: add tap device backend
Date: Fri, 7 Aug 2009 12:47:38 -0700
Message-ID: <005601ca1797$ef5dc180$ce194480$@edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcoXlk7qCfCSU+aDRoumxvWKqbhLTQAATsWA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I do have to raise the point that Linux is perfectly capable of keeping
> up without
> the need of an external switch.  Whether you want policy external or
> internal is
> a architecture decision that should not be driven by mis-information
> about performance.

No argument here.  I agree that you can do a lot in Linux.  It is, as you
say, an architecture decision, that can be enabled with this addition mode
of operation.  Without the mode of forcing things external, however, you
would always need to put this function internal or play games with VLANs
overlapping to get traffic to forward the way you want it.

Paul

