Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZJ0RYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZJ0RYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZJ0RYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:24:24 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50224 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbZJ0RYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:24:23 -0400
Date: Tue, 27 Oct 2009 18:24:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] i2c-scmi: support IBM SMBus CMI devices
Message-ID: <20091027182425.31d09784@hyperion.delvare>
In-Reply-To: <20091026210024.GS26149@tux1.beaverton.ibm.com>
References: <20091020231149.GM26149@tux1.beaverton.ibm.com>
	<20091021023016.GC32413@crane-desktop>
	<200910210857.13978.bjorn.helgaas@hp.com>
	<20091021173733.GN26149@tux1.beaverton.ibm.com>
	<20091022071748.GA17917@crane-desktop>
	<20091022174304.GO26149@tux1.beaverton.ibm.com>
	<20091023044451.GB1367@crane-desktop>
	<20091023170311.GC21723@tux1.beaverton.ibm.com>
	<20091025125353.55d3bfad@hyperion.delvare>
	<20091026210024.GS26149@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 14:00:24 -0700, Darrick J. Wong wrote:
> From: Crane Cai <crane.cai@amd.com>
> 
> *) add a new HID for IBM SMBus CMI devices
> *) add methods for IBM SMBus CMI devices
> *) hook different HID with different control methods set
> *) minor tweaks as suggested by Jean Delvare
> 
> Slightly modified by Darrick to use #define'd IBM SMBUS HID from Darrick's ACPI
> scan quirk patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Signed-off-by: Crane Cai <crane.cai@amd.com>
> ---
> 
>  drivers/i2c/busses/i2c-scmi.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Jean Delvare
