Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbXGHNpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbXGHNpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXGHNpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:45:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:37701 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbXGHNpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:45:40 -0400
Message-ID: <4690EA8A.3020705@qumranet.com>
Date: Sun, 08 Jul 2007 16:45:46 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 11/20] KVM: SVM: Reliably detect if SVM was disabled by
 BIOS
References: <11838956891287-git-send-email-avi@qumranet.com>	<11838956892580-git-send-email-avi@qumranet.com> <aday7hr105d.fsf@cisco.com>
In-Reply-To: <aday7hr105d.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> seems like we probably want this for 2.6.22... it fixes a panic that
> I've seen actually reported by several users.  Is there any risk to
> merging it?
>
> i guess getting it into 2.6.22.1 would be OK too.
>   

Well, there were reports of miscompiles with the original patch.  This 
one is hopefully fixed.  I'll wait a day or two and upstream it.

-- 
error compiling committee.c: too many arguments to function

