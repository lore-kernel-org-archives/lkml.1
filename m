Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZBNWql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZBNWql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZBNWqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:46:33 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:14287 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbZBNWqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:46:32 -0500
From: Frans Pop <elendil@planet.nl>
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: cpuinfo shows wrong MHz value
Date: Sat, 14 Feb 2009 23:46:29 +0100
User-Agent: KMail/1.9.9
Cc: Joerg Platte <jplatte@naasa.net>, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <200902142329.31428.elendil@planet.nl> <1234651096.13338.15.camel@localhost>
In-Reply-To: <1234651096.13338.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142346.30449.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2009 22:46:31.0108 (UTC) FILETIME=[14567840:01C98EF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009, Kasper Sandberg wrote:
> I dont think cpu frequency scaling can suddenly make a cpu go from
> 1.6ghz to 13ghz, but if it can, i sure want one!

Ah, sorry. I misread the message and thought the problem was it was 
showing 1.3 GHz, which would be a very normal scaling value.

However, it would have helped if the problem had been stated explicitly in 
the original message instead of letting others interpret the raw data.
