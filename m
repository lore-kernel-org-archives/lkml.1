Return-Path: <linux-kernel-owner+w=401wt.eu-S1764670AbXF1JXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764670AbXF1JXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXF1JX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:23:26 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:53532 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbXF1JXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:23:25 -0400
In-Reply-To: <20070628002438.GB15298@localhost.localdomain>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com> <20070628002438.GB15298@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f297007fcff5c94d8a91a6739f112910@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Zhang Wei <wei.zhang@freescale.com>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5 v2] Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Thu, 28 Jun 2007 11:23:22 +0200
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> +   k) RapidIO
>> +
>> +   Required properties:
>
> Should probably recommend a name for the node here, as well.  "srio" I
> guess, from the example below.

I would prefer "rapidio", being more generic and more
readable.  What would parallel RapidIO be, "prio"?  No
thanks :-)


Segher

