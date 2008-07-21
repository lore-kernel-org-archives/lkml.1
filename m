Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYGUSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYGUSwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYGUSwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:52:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43058 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYGUSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:52:12 -0400
Subject: Re: ACPI: ACPI_CUSTOM_DSDT_INITRD option
From: Ben Collins <ben.collins@canonical.com>
To: "Joshua C." <joshuacov@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5f6f8c5f0807210344l676f5730n3eb31c79a025d0ce@mail.gmail.com>
References: <5f6f8c5f0807210344l676f5730n3eb31c79a025d0ce@mail.gmail.com>
Content-Type: text/plain
Organization: Canonical
Date: Mon, 21 Jul 2008 14:52:08 -0400
Message-Id: <1216666328.7585.169.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 12:44 +0200, Joshua C. wrote:
> This feature was considered problematic for the 2.6.25 kernel. And the
> 0.9x version was rewritten to make the patch work better with the new
> kernel (here it is: http://gaugusch.at/kernel.shtml ). What about
> adding it to the new 2.6.27?

Could you rebase it on latest git (lots of fuzz)? Other than that, it
looks good to me. We've been carrying this patch forever, so would be
nice to have it applied upstream finally.

