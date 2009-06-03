Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZFCIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZFCIKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbZFCIKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:10:05 -0400
Received: from main.gmane.org ([80.91.229.2]:46407 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbZFCIKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:10:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Christian Tramnitz <christian@tramnitz.com>
Subject: Re: Merge Xen (the hypervisor) into Linux
Date: Wed, 03 Jun 2009 10:07:39 +0200
Message-ID: <4A262F4B.8010404@tramnitz.com>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 81.210.217.68
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
In-Reply-To: <20090602232843.GA6577@elte.hu>
Cc: xen-devel@lists.xensource.com, xen-users@lists.xensource.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> A lot of Xen legacies could be dropped: the crazy ring1 hack on 
> 32-bit, the various wide interfaces to make pure-software 
> virtualization limp along. All major CPUs shipped with hardware 
> virtualization support in the past 2-3 years, so the availability of 
> VMX and SVM can be taken for granted for such a project.

What a great idea, and while we're doing this let's also drop support
for legacy stuff like PATA and i8042 in mainline. Noone will need it
anyway because their successors are on the market for years... let's
just take it for granted that everyone is using SATA and USB nowadays!


Best regards,
   Christian

