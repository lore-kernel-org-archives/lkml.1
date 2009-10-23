Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZJWSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZJWSZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZJWSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:25:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55116 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbZJWSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:25:44 -0400
Message-ID: <4AE1F525.5090207@pobox.com>
Date: Fri, 23 Oct 2009 14:25:41 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Ceuleers <jan.ceuleers@computer.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, stable@kernel.org
Subject: Re: pata sc1200 fix crash boot, bug #14227
References: <4AE1F29B.1090009@computer.org>
In-Reply-To: <4AE1F29B.1090009@computer.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2009 02:14 PM, Jan Ceuleers wrote:
> A little while ago [1], a fix was posted here for a boot-time crash in the sc1200 module.
>
> [1]: http://marc.info/?l=linux-kernel&m=125484259025909&w=2
>
> Submission to stable was also briefly discussed, but has apparently not happened, despite the fact that this bug appears to have existed since 2.6.29.
>
> I would therefore like to request that this fix now be submitted to stable.

Looks like commit 6d4f950e9ea15816c6a4f266ce6b9e438346771e is missing 
the "CC:stable@kernel.org".  Added implicitly via this message...


