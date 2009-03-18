Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZCRVEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZCRVEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCRVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:03:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54869
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbZCRVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:03:53 -0400
Date: Wed, 18 Mar 2009 14:03:40 -0700 (PDT)
Message-Id: <20090318.140340.55290859.davem@davemloft.net>
To: andi@firstfloor.org
Cc: vernux@us.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <87prge1rhu.fsf@basil.nowhere.org>
References: <49C12E64.1000301@us.ibm.com>
	<87prge1rhu.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 18 Mar 2009 21:54:37 +0100

> But then again I'm not sure it's  worth it if the problem only
> happens in out of tree RT.

The list of problems that only show up with the RT kernel seems to be
constantly increasing, but honestly is very surprising to me.

I don't understand why we even need to be concerned about this stuff
upstream, to be honest.

Please reproduce this in the vanilla kernel, then get back to us.
