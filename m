Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbYHUSS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbYHUSS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYHUSSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:18:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYHUSSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:18:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Date: Thu, 21 Aug 2008 20:22:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
In-Reply-To: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212022.18598.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> Hi,
> 
> I just got this on v2.6.27-rc4 (+ unrelated fix):
> 
> ACPI: Preparing to enter system sleep state S5

This looks fishy.

Please check what's there in /sys/power/disk .

Also, can you please post the full dmesg containing those traces?

Rafael
