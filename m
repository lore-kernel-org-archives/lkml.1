Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYEYVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYEYVbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYEYVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:31:21 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:60739 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751269AbYEYVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:31:20 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Kernel checking options
Date: Sun, 25 May 2008 22:31:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <g1cfbn$uic$1@ger.gmane.org>
In-Reply-To: <g1cfbn$uic$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252231.18095.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 20:27:36 Sitsofe Wheeler wrote:
> Is this list complete? Are they all enabling additional checks?
>
> Additionally are there any options that will make (real) bugs more likely
> to occur? For example does preemption make bugs related to races (that
> could happen without preemption) happen more often?

You're missing the IOMMU test code, which is only available on x86-64 systems.

There might be some other architecture specific options you've missed.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
