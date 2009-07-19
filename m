Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZGSSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZGSSZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZGSSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:25:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58127 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZGSSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:25:38 -0400
Date: Sun, 19 Jul 2009 19:25:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
Message-ID: <20090719182533.GA11496@srcf.ucam.org>
References: <4A61FE7D.9080409@tuffmail.co.uk> <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com> <4A623490.50305@tuffmail.co.uk> <8db1092f0907190028o334371d7g798c1e8cb9a5744b@mail.gmail.com> <4A635618.3070507@tuffmail.co.uk> <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 08:10:23PM +0200, Maciej Rutecki wrote:

> LED from wifi/bluetooth button sometimes flashing(!)

The LED will flash if wifi is enabled and bluetooth isn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
