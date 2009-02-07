Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZBGVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZBGVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 16:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBGVZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 16:25:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43974 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZBGVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 16:25:09 -0500
Date: Sat, 7 Feb 2009 13:20:22 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
Message-ID: <20090207212022.GA25353@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117202638.GA11825@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| Patches in this set:
| 
| 	[PATCH 1/7] Remove 'handler' parameter to tracehook functions
| 	[PATCH 2/7] Protect init from unwanted signals more
| 	[PATCH 3/7] Add from_ancestor_ns parameter to send_signal()
| 	[PATCH 4/7] Protect cinit from unblocked SIG_DFL signals
| 	[PATCH 5/7] Protect cinit from blocked fatal signals
| 	[PATCH 6/7] SI_USER: Masquerade si_pid when crossing pid ns boundary
| 	[PATCH 7/7] proc: Show SIG_DFL signals to init as "ignored" signals

Roland, Eric, Daniel, Pavel

Any comments on this patchset ? We are not sure about patch 7, but should
I send the rest to Andrew ?

Sukadev
