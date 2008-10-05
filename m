Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYJEVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYJEVdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYJEVdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:33:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60308 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYJEVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:33:41 -0400
Date: Sun, 5 Oct 2008 22:33:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: IvDoorn@gmail.com, hmh@hmh.eng.br, sitsofe@yahoo.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Message-ID: <20081005213330.GA11355@srcf.ucam.org>
References: <20081004204342.GA29620@srcf.ucam.org> <20081005004334.GA31844@srcf.ucam.org> <20081005110226.GB4087@srcf.ucam.org> <20081005212432.GC11576@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005212432.GC11576@amd.corenet.prv>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:24:39PM -0400, Dmitry Torokhov wrote:

> I'd rather have something like below. It should probably go through
> David's (networking) tree. since it is in net/.

Fine with me, as long as Sitsofe can confirm it works?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
