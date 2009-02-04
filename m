Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZBDMDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZBDMDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZBDMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:02:53 -0500
Received: from cpsmtpo-eml05.KPNXCHANGE.COM ([213.75.38.154]:15156 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbZBDMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:02:52 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Comparison between .28 and .29-rc3 for STR cycle
Date: Wed, 4 Feb 2009 13:02:48 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <200902031237.53579.elendil@planet.nl>
In-Reply-To: <200902031237.53579.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041302.49497.elendil@planet.nl>
X-OriginalArrivalTime: 04 Feb 2009 12:02:50.0139 (UTC) FILETIME=[8050C6B0:01C986C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, you wrote:
> # Weird, we already did a config restore at offset 0x7 4 lines up!
> # So where does this next line come from?
>  +pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)

This line is gone with Rafael's latest PM IDE patch series applied.
