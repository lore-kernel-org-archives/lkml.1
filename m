Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYCPXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYCPXDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYCPXDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:03:04 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:44810 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752772AbYCPXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:03:03 -0400
X-YMail-OSG: 6I0OkdIVM1kWO2kph6UEmhGDZzrpV8zGFVX2ZPpgNfN23eW5Kt6ClQzqalfrBp.Ji1mL5_7yRA--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 16 Mar 2008 16:02:56 -0700
From: Chris Wedgwood <cw@f00f.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: USB oops with mainline (post 2.6.25-rc5)
Message-ID: <20080316230256.GA3977@puku.stupidest.org>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120313.23568.david-b@pacbell.net> <20080316223257.GA4095@puku.stupidest.org> <200803161543.37993.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803161543.37993.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc' list trimmed)

On Sun, Mar 16, 2008 at 02:43:37PM -0800, David Brownell wrote:

> Are you sure it's the same problem?

Indeed it's not, the earlier problem seems to have gone away.  I just
saw the oops and read ub as urb and didn't think past the fact it
crashed earlier.  Sorry about that.

> Does that happen with usb-storage too, or just "ub"?  ISTR hearing
> about similar issues specific to "ub".

It's ub specific and reproducable.  With usb-storage everything works
as expected.

I'll post the UB oops in a few minutes.
