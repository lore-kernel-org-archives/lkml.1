Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXKYGky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXKYGky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 01:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXKYGju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 01:39:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbXKYGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 01:39:48 -0500
Date: Sat, 24 Nov 2007 22:39:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeroen <j.geusebroek@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: forcedeth ethernet driver & Low power state
Message-Id: <20071124223928.796a4c6e.akpm@linux-foundation.org>
In-Reply-To: <c22ebab10711241852v687b384fpd638ff565756232a@mail.gmail.com>
References: <c22ebab10711241852v687b384fpd638ff565756232a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 03:52:33 +0100 Jeroen <j.geusebroek@gmail.com> wrote:

> Hi,
> 
> I'm migrating my server from windows 2003 server to Ubuntu, but I am
> stumbling over the "Low Power State Link Speed" option for my NIC
> (forcedeth)
> 
> I need to disable this option in my windows driver otherwise the trough pout is
> horrible because the link fluctuates constantly from 100/1000.
> 
> Anyway, my question is where and how can I turn off this feature for the
> forcedeth driver? I've looked in the source and as far as I can tell there is no
> bootoption for this. There are some references noted in the code, but AFAIK
> no setting.
> 
> Any ideas? Thanks in advance!
> 

(cc's added)
