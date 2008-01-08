Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYAHHJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYAHHJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYAHHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:09:05 -0500
Received: from adsl42-105.ath.forthnet.gr ([77.49.73.105]:59504 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbYAHHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:09:03 -0500
Message-ID: <478320ED.2010601@asyr.hopto.org>
Date: Tue, 08 Jan 2008 09:06:21 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: NIC as RS232
References: <47831CC3.9080604@asyr.hopto.org>
In-Reply-To: <47831CC3.9080604@asyr.hopto.org>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 01/08/2008 08:48 AM Thanasis wrote the following:
> Is there a kernel driver that would make a NIC's port work as a RS232
> port, using the serial cables that are RJ45 on one side and DB9 or DB25
> on the other? Maybe null modem cables of that type ? Or for example
> those used by cisco as console port cables?
> 
> (or may be I'm dreaming ;-)
> 
> 
> ------------------------------------------------------------------------
> 

Forget my previous question, as I understand now that I gave it a more
serious thought, that it is not a matter of driver, but an
incompatibility between the two in the layer/media carrier level.
(Yea, I was dreaming  :-)
