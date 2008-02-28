Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYB1Pua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYB1Pua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbYB1PuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:50:06 -0500
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:26753 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760328AbYB1PuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:50:04 -0500
From: Frans Pop <elendil@planet.nl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
Date: Thu, 28 Feb 2008 16:50:01 +0100
User-Agent: KMail/1.9.7
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <1204056556.7745.22.camel@localhost> <E1JULSV-0001qy-7N@faramir.fjphome.nl> <1204190794.16668.4.camel@pern>
In-Reply-To: <1204190794.16668.4.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281650.02471.elendil@planet.nl>
X-OriginalArrivalTime: 28 Feb 2008 15:50:02.0931 (UTC) FILETIME=[94D14030:01C87A21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008, Romano Giannetti wrote:
> On Wed, 2008-02-27 at 13:32 +0100, Frans Pop wrote:
> > This sounds like that could be a bug I filed recently and which was
> > solved in 2.2.1: http://bugs.freedesktop.org/show_bug.cgi?id=14481.
>
> Yes, it seems the same. I will try as soon as I came around to a way to
> do it.
>
> Could this account to the LCD/CRT switching problem to?

I'm afraid I can't help you there.

As I said before, the only way to make sure is to see if the problem gets 
solved if you boot the system with an older kernel version.
