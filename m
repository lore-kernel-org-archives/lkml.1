Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYDOTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYDOTxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbYDOTxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:53:10 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60481 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbYDOTxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:53:09 -0400
Date: Tue, 15 Apr 2008 21:53:55 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 regression: 60417f5976df breaks Thinkpad suspend
Message-ID: <20080415195355.GB31569@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080415115326.9915.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415115326.9915.qmail@science.horizon.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 07:53:26 -0400, George Spelvin wrote:
> IBM Thinkpad T21, "type 2647".  biosdecode says "Machine Type/Model:
> 26478AU" and "BIOS Build ID: KZET22WW".  Early ACPI boot messages are

I could try to reproduce it on a T20, and also the "fix" you mentioned.

Regards,
Tino
