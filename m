Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbYBFICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbYBFICe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbYBFICZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:02:25 -0500
Received: from mail.kapp-coburg.de ([217.24.55.52]:55433 "EHLO
	mail.kapp-coburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760202AbYBFICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:02:24 -0500
Message-ID: <47A96983.1090108@niles.de>
Date: Wed, 06 Feb 2008 09:02:11 +0100
From: "Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de>
Organization: NILES Werkzeugmaschinen GmbH
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Stuge, Peter" <stuge-linux-pcmcia@cdy.org>
Subject: Resolved (sort of): Unable to access PCMCIA with O2 Micro OZ711MP1/MS1
References: <47A7F828.1010303@niles.de> <20080205140622.bf41f3ce.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080205140622.bf41f3ce.Kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson schrieb:
> "Mader, Alexander (N-MSR)" wrote:
>> On a Fujitsu Siemens Celsius H240 a 2.6.22-3-amd64 kernel from Debian 
>> testing is in use. PCMCIA utilities for Linux 2.6 version 014-4 are 
>> installed. I could supply the output of lspci and lshal.
> 
> Assuming debian has alot of patches applied, it would be interesting to see
> if this bug exist on vanilla 2.6.24. Would probably get alot more attention from
> pcmcia guru's.

Hello,

obviously this is the case. This morning I tried a different non-cardbus 
PCMCIA card and it worked, which in turn was the case for the other test 
candidates, NICs and CF adapters: they all are accessible right now. In 
the moment I am trying to find out which update caused the improvement.

Thank you very much for your attention and, please, excuse me for 
bothering you.

Best regards, Alexander.
