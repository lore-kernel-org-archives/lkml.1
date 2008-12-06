Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbYLFQpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbYLFQpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYLFQpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:45:05 -0500
Received: from www.crouse-house.com ([199.45.160.146]:51395 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYLFQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:45:05 -0500
Message-ID: <493AAC0E.6090005@cosmicpenguin.net>
Date: Sat, 06 Dec 2008 09:45:02 -0700
From: Jordan Crouse <jordan@cosmicpenguin.net>
Reply-To: jordan@cosmicpenguin.net
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de> <493961EE.6000002@cosmicpenguin.net> <493A8A63.2020400@t-online.de>
In-Reply-To: <493A8A63.2020400@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi Jordan,
> 
> Sorry for the empty reply. I clicked on [Send] by accident.
> 
> Jordan Crouse wrote:
>>
>> Hmm - we've heard reports of this before, but nothing came of it.  I 
>> would be interested in a chance to debug it this time.
>>
>> Please try turning off CONFIG_GEODE_MFGPT_TIMER=y and try again.
> 
> AFAICS this was already set.

You mean set prior to 2.6.27?  I know, but if there is a regression, 
that would help narrow it down.

Jordan

