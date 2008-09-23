Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYIWO2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYIWO2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYIWO20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:28:26 -0400
Received: from styx.suse.cz ([82.119.242.94]:33083 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751550AbYIWO2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:28:25 -0400
Date: Tue, 23 Sep 2008 16:29:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Miller <davem@davemloft.net>, david.vrabel@csr.com
cc: airlied@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <20080922.185902.80812984.davem@davemloft.net>
Message-ID: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
References: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz> <20080922.152815.22060684.davem@davemloft.net> <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com> <20080922.185902.80812984.davem@davemloft.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008, David Miller wrote:

> So I went through the changes from 2.6.27-rc5 until the SHA1
> ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
> definitely no E1000 or E1000E changes during that time.

Some recent comments on [1] seem to indicate that this is somehow coupled 
into prior problems/panics with Intel graphics. 

David, was this also your case, or did the EEPROM got garbled out of a 
sudden?

[1] https://bugzilla.novell.com/show_bug.cgi?id=425480

-- 
Jiri Kosina
SUSE Labs
