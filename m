Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYGaUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYGaUJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYGaUJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:09:05 -0400
Received: from gw.goop.org ([64.81.55.164]:35457 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbYGaUJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:09:04 -0400
Message-ID: <48921BDD.4050009@goop.org>
Date: Thu, 31 Jul 2008 13:09:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] xen-netfront: call netif_start_queue() on	xennet_open()
References: <1216912546-6971-1-git-send-email-ehabkost@redhat.com> <1216912546-6971-2-git-send-email-ehabkost@redhat.com> <4888A3B7.8060901@goop.org> <4888CA2A.1060509@garzik.org> <4888CC5D.9030800@goop.org> <20080731200323.GK7753@blackpad>
In-Reply-To: <20080731200323.GK7753@blackpad>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> I didn't find it on any git repository. Is it queued somewhere? If not,
> should I resend?
>   

Yes, I think it fell through the cracks.  Resend to Jeff.

    J
