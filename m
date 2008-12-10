Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYLJU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYLJU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYLJU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:56:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42217 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYLJU4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:56:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49402CBD.9020706@s5r6.in-berlin.de>
Date: Wed, 10 Dec 2008 21:55:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
References: <200812061316.38460.elendil@planet.nl> <493B953F.3070504@s5r6.in-berlin.de> <493C1C8F.5070003@shaw.ca> <200812101424.42755.elendil@planet.nl>
In-Reply-To: <200812101424.42755.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Any suggestions how to try and trace if that's what's happening?

Test after booting with the kernel parameter nomsi.
-- 
Stefan Richter
-=====-==--- ==-- -=-=-
http://arcgraph.de/sr/
