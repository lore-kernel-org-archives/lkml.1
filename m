Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXA3XHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXA3XHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXA3XHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:07:32 -0500
Received: from dhost002-81.dex002.intermedia.net ([64.78.20.214]:50028 "EHLO
	dhost002-81.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbXA3XHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:07:30 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Tue, 30 Jan 2007 14:53:13 -0800
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Dan Williams <dcbw@redhat.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Marks <pmarks@purdue.edu>
Subject: Re: Hidden SSID's
Message-ID: <20070130225313.GG32304@instant802.com>
References: <45BACB71.2080107@lwfinger.net> <1169899689.25670.3.camel@localhost.localdomain> <45BD2119.2000209@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BD2119.2000209@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 30 Jan 2007 22:53:14.0111 (UTC) FILETIME=[6C6258F0:01C744C1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:18:01PM -0600, Larry Finger wrote:

> Is there something funny about Cisco APs with hidden SSID?

Yes, there is.. Or well, "hidden SSID" is funny concept in itself, but
anyway.. Some APs set the SSID IE to an array of 0x00 octets with the
length of the original SSID when "hiding" the SSID while others just use
0-length SSID.

-- 
Jouni Malinen                                            PGP id EFC895FA
