Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYIFAJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYIFAJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 20:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIFAJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 20:09:42 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:11690 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYIFAJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 20:09:41 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Sat, 6 Sep 2008 02:09:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200809060025.20039.elendil@planet.nl> <200809060118.38493.rjw@sisk.pl>
In-Reply-To: <200809060118.38493.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809060209.37353.elendil@planet.nl>
X-OriginalArrivalTime: 06 Sep 2008 00:09:39.0319 (UTC) FILETIME=[DA9F9070:01C90FB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 September 2008, Rafael J. Wysocki wrote:
> Thanks.  There's a new patch for you to test in there already. :-)

Seems to work correctly. The first spindown no longer happens.

In the BTS you noted the support is "partial". What's partial about it?

Thanks Rafael.
