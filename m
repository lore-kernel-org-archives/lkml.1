Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYIWQkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYIWQkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYIWQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:39:51 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:58670 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIWQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:39:50 -0400
Message-ID: <48D91B9B.7010903@diamondcut.com.br>
Date: Tue, 23 Sep 2008 13:38:51 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: David Miller <davem@davemloft.net>, david.vrabel@csr.com,
       airlied@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com,
       john.ronciak@intel.com, bruce.w.allan@intel.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz> <20080922.152815.22060684.davem@davemloft.net> <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com> <20080922.185902.80812984.davem@davemloft.net> <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Some recent comments on [1] seem to indicate that this is somehow coupled 
> into prior problems/panics with Intel graphics. 
> 
> David, was this also your case, or did the EEPROM got garbled out of a 
> sudden?
> [1] https://bugzilla.novell.com/show_bug.cgi?id=425480

And...
<http://lwn.net/Articles/299787>
<http://bugzilla.kernel.org/show_bug.cgi?id=11382>
<https://bugzilla.redhat.com/show_bug.cgi?id=459202>
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/263555>

Best regards,
Renato
