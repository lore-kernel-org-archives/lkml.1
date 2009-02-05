Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZBERYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZBERYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZBERXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:23:55 -0500
Received: from gw.goop.org ([64.81.55.164]:57652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBERXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:23:54 -0500
Message-ID: <498B20A7.4060405@goop.org>
Date: Thu, 05 Feb 2009 09:23:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
References: <498A5002.9080408@goop.org> <20090205142912.GE28443@elte.hu>
In-Reply-To: <20090205142912.GE28443@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., did you actually see a boot crash due to this, on a pre-PGE system?
>   

No, under Xen, since it also disables PGE.

    J
