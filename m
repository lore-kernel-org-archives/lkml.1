Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYIEWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYIEWZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 18:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYIEWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 18:25:24 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:56310 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbYIEWZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 18:25:23 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Sat, 6 Sep 2008 00:25:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200808291330.42265.elendil@planet.nl> <200809041605.22055.rjw@sisk.pl>
In-Reply-To: <200809041605.22055.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809060025.20039.elendil@planet.nl>
X-OriginalArrivalTime: 05 Sep 2008 22:25:20.0158 (UTC) FILETIME=[47DF63E0:01C90FA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2008, Rafael J. Wysocki wrote:
> I have uploaded a new version of the patch into the Bugzilla:
> http://bugzilla.kernel.org/attachment.cgi?id=17618&action=view

This version does not work for me, possibly because I use a different hard 
disk driver (ata_piix instead of sata_sil)?

I've seen there are later versions of the patch, but as the comments 
mention that 2510p was removed from those I haven't tested them.

> (also please attach dmesg output to the Bugzilla entry)

Added.

Cheers,
FJP
