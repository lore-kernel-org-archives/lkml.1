Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZCNPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZCNPOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZCNPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:14:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:38907 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZCNPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20090314104204.GA11226@mobydick>
References: <20090314104204.GA11226@mobydick>
Date: Sat, 14 Mar 2009 16:14:19 +0100
Message-ID: <ac3eb2510903140814t26954869m4f07623c25b5948f@mail.gmail.com>
Subject: Re: [PATCH] thinkpad-acpi: fix module autoloading for older models
From: Kay Sievers <kay.sievers@vrfy.org>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Len Brown <lenb@kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       stable@kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 11:42, Mathieu Chouquet-Stringer
<mchouque@free.fr> wrote:

> While for older Thinkpads, you do this (for instance):
> IBM_BIOS_MODULE_ALIAS("1[0,3,6,8,A-G,I,K,M-P,S,T]");

Aliases are shell-style globs. Any idea what the ',' are doing in a
character class? Confused ...

Thanks,
Kay
