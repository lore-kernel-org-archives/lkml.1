Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbXFRUHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbXFRUHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761800AbXFRUHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:07:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761550AbXFRUHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:07:11 -0400
Date: Mon, 18 Jun 2007 16:07:03 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Garzik <jeff@garzik.org>, Nigel Kukard <nkukard@lbsd.net>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA problems
Message-ID: <20070618200703.GB13344@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Garzik <jeff@garzik.org>, Nigel Kukard <nkukard@lbsd.net>,
	linux-kernel@vger.kernel.org
References: <4671366B.7090702@lbsd.net> <46716B1D.1070902@garzik.org> <20070614182854.GC1223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614182854.GC1223@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 02:28:54PM -0400, Dave Jones wrote:
 > On Thu, Jun 14, 2007 at 12:21:49PM -0400, Jeff Garzik wrote:
 > 
 >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
 >  > > 0x0001c807
 >  > > Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
 >  > > 0x0001c807
 > 
 > Unrelated to the other error, but I've been meaning to ask for a while..
 > If this is 'abnormal', why does every SATA box I've seen do it?

*crickets*

Should we check for this case explicitly, and not print this?

	Dave

-- 
http://www.codemonkey.org.uk
