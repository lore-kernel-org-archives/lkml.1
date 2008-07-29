Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbYG2S5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbYG2S5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2S5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:57:06 -0400
Received: from bay0-omc3-s25.bay0.hotmail.com ([65.54.246.225]:41912 "EHLO
	bay0-omc3-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbYG2S5F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:57:05 -0400
Message-ID: <BAY103-W38794846AA924235B38E47B2820@phx.gbl>
X-Originating-IP: [217.201.129.59]
From: Marco Berizzi <pupilla@hotmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
       <tim.bird@am.sony.com>
Subject: RE: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console
 on slackware 12.1
Date: Tue, 29 Jul 2008 20:57:02 +0200
Importance: Normal
In-Reply-To: <200807291815.13907.alistair@devzero.co.uk>
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl>
 <200807291815.13907.alistair@devzero.co.uk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jul 2008 18:57:03.0019 (UTC) FILETIME=[E34CCFB0:01C8F1AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


alistair@devzero.co.uk wrote:

> You don't actually say whether you had CONFIG_CONSOLE_TRANSLATIONS=y or not?

yes console_translation is set to yes. It cannot be changed if embedded is not
set.
_________________________________________________________________
Connect to the next generation of MSN Messenger 
http://imagine-msn.com/messenger/launch80/default.aspx?locale=en-us&source=wlmailtagline