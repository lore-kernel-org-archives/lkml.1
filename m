Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXHAVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXHAVVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXHAVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:21:18 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:45466 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXHAVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:21:17 -0400
Message-ID: <46B0F8AF.9000000@gmail.com>
Date: Wed, 01 Aug 2007 23:18:39 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andi Kleen <ak@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
References: <200708011433.09433.ak@novell.com> <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 08:30 PM, Jan Engelhardt wrote:

> On Aug 1 2007 14:33, Andi Kleen wrote:
>> Comments?
> 
> A kconfig entry "(OBSOLETE)"/"(DEPRECATED)" would be nice. (And if you
> want to test people, 'depends on EMBEDDED' for CONFIG_BINFMT_AOUT)

Or just remove that junk.

Rene.
