Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYKYJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYKYJmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYKYJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:42:30 -0500
Received: from xsmtp1.ethz.ch ([82.130.70.13]:36777 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYKYJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:42:29 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 04:42:29 EST
Date: Tue, 25 Nov 2008 10:27:14 +0100
From: Mathias Weyland <weyland@library.ethz.ch>
To: Philip Langdale <philipl@overt.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Message-ID: <20081125092714.GA2763@katjusha>
References: <492BBA91.5010302@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492BBA91.5010302@overt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 25 Nov 2008 09:27:15.0029 (UTC) FILETIME=[00D3C850:01C94EE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:42:57AM -0800, Philip Langdale wrote:

Hello

> The latest generation of laptops are shipping with a newer
> model of Ricoh chip where the firewire controller is the
> primary PCI function but a cardbus controller is also present.

I'm confirming that my latest generation laptop now works with your
patch. 

Best regards

Matt
