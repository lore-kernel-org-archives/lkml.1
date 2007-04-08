Return-Path: <linux-kernel-owner+w=401wt.eu-S966034AbXDHAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966034AbXDHAlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966032AbXDHAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:41:15 -0400
Received: from khc.piap.pl ([195.187.100.11]:35484 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966019AbXDHAlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:41:13 -0400
To: Valdis.Kletnieks@vt.edu
Cc: johnrobertbanks@fastmail.fm, Jan Harkes <jaharkes@cs.cmu.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
References: <46157B5B.5000602@gmail.com>
	<1175817921.18400.1183285196@webmail.messagingengine.com>
	<461592FB.5060507@zytor.com>
	<1175819681.20754.1183287946@webmail.messagingengine.com>
	<461596DE.2020802@zytor.com>
	<1175823288.25662.1183293506@webmail.messagingengine.com>
	<4615C780.5040407@zytor.com>
	<1175833931.8916.1183307802@webmail.messagingengine.com>
	<20070406152119.GC4228@delft.aura.cs.cmu.edu>
	<1175914056.9653.1183426876@webmail.messagingengine.com>
	<20070407033049.GI4228@delft.aura.cs.cmu.edu>
	<1175925525.21154.1183436614@webmail.messagingengine.com>
	<m34pns46l9.fsf@maximus.localdomain>
	<14133.1175966465@turing-police.cc.vt.edu>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 08 Apr 2007 02:41:10 +0200
In-Reply-To: <14133.1175966465@turing-police.cc.vt.edu> (Valdis Kletnieks's message of "Sat, 07 Apr 2007 13:21:05 -0400")
Message-ID: <m33b3b3dg9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> I am quite sure that the kernel RPM file is *already* compressed, at least
> somewhat.

Sure - that's the point - it's better to have the tool compress
data when it makes sense.

OTOH I think Reiser4 fs is not about transparent compression, it's
rather about the plugins etc. There are other filesystems with
transparent compression, that's nothing new.
-- 
Krzysztof Halasa
