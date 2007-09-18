Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbXIRIyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbXIRIyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXIRIy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:54:27 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:32889 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbXIRIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:54:26 -0400
Message-ID: <46EF9103.6050105@linux-kernel.at>
Date: Tue, 18 Sep 2007 10:49:07 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at> <46EEEE57.6010404@zytor.com>
In-Reply-To: <46EEEE57.6010404@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2007 11:15 PM, H. Peter Anvin wrote:
> Oliver Falk wrote:
>> As these additions are quite new to upstream kernel, but at Alphacore we
>> have patched it since a while now (I don't know about other Alpha ports;
>> Debian folks may speak up now!), I would suggest to use the same
>> 'ordering' of the syscalls upstream and add the new syscalls that we had
>> not in place, but are now upstream to the end of our 'old' list.
>>
> 
> If you want to avoid that in the future, you may want to push your
> changes upstream.

Sure, sure! I wasn't the one who actually did patch that, I just took
what was there...

I'll will submit any relevant patches to upstream from now on!

Best,
 Oliver
