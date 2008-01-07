Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYAGXdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYAGXdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYAGXd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:33:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:47966 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYAGXd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:33:27 -0500
Subject: Re: [PATCH][POWERPC] Workaround for iommu page alignment
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: michael@ellerman.id.au
Cc: Paul Mackerras <paulus@samba.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1199745684.7518.25.camel@concordia>
References: <1199742359.6734.14.camel@pasglop>
	 <1199745684.7518.25.camel@concordia>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 10:33:01 +1100
Message-Id: <1199748781.6734.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't see in the code where you implement the "size > PAGE_SIZE"
> condition. But I only just got back from holidays .. :)

Indeed ... a "quilt ref" was missing :-(

New patch coming ...

Ben.


