Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYKCPxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYKCPxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYKCPxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:53:04 -0500
Received: from os.eurotux.com ([216.75.63.6]:38738 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbYKCPxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:53:03 -0500
Date: Mon, 3 Nov 2008 15:52:55 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: usb hdd problems with 2.6.27.2
Message-ID: <20081103155254.GA3368@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	SCSI development list <linux-scsi@vger.kernel.org>
References: <20081028163722.GA4374@bit.office.eurotux.com> <Pine.LNX.4.44L0.0810281331260.2190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0810281331260.2190-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 01:38:11PM -0400, Alan Stern wrote:
> > Do you wish me to test anything else?
> 
> Yes.  Please post a usbmon trace for each of the last two tests.  That 
> is, with the unusual_devs update only, and with the unusual_devs update 
> plus the invoke_transport update and the scsi_requeue_command update.

I've updated the bugzilla entry with traces for some combinations of the
discussed patches:
http://bugzilla.kernel.org/show_bug.cgi?id=11843

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
