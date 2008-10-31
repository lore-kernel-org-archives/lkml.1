Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbYJaQKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbYJaQKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYJaQKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:10:08 -0400
Received: from main.gmane.org ([80.91.229.2]:35842 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYJaQKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:10:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
Date: Fri, 31 Oct 2008 17:08:20 +0100
Organization: ComX Networks A/S
Message-ID: <gefahl$rcu$1@ger.gmane.org>
References: <4909F690.9090208@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: nat-dhcp.lanfw.cxnet.dk
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric (and related people touching the code),

Just to confirm your observations (as you have a ? in subj); 
 oprofile is also broken for me on kernel 2.6.28-rc2.

(Related people Cc'ed
 git log v2.6.27.. drivers/oprofile/ | grep Author: | sort  |uniq)


Eric Dumazet wrote:

> I tried to start my favorite tool, and discovered it wont fly on my HP
> BL460C G1

My hardware: HP-proliant DL380-G5
CPU: Intel(R) Xeon(R) CPU E5335  @ 2.00GHz

> It samples few events then, seems to stop (no more NMI), other than that,
> machine still running correctly.

Same observation.

> It is working correctly on 2.6.27

Same observation.


