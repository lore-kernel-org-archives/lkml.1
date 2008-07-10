Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYGJQXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYGJQXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYGJQWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:22:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbYGJQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:22:53 -0400
Date: Thu, 10 Jul 2008 17:21:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile phones
Message-ID: <20080710162158.GG10441@flint.arm.linux.org.uk>
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org> <48730DE2.2050302@gmail.com> <4873734F.4030808@gmail.com> <20080708203213.GF18479@datenfreihafen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708203213.GF18479@datenfreihafen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 10:32:13PM +0200, Stefan Schmidt wrote:
> Daniel fixed all of Philipps comments besides the voltage framework. From Eric
> comments we updated to the new IRQ part and moved to platform data.

Due to the problems people were seeing with the IRQ numbering commit, we
(Eric and myself) have decided to drop that commit for the time being.
It will reappear after this merge window however.
