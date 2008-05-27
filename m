Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbYE0SMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbYE0SMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYE0SMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:12:07 -0400
Received: from trinity.fluff.org ([89.145.97.151]:58846 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbYE0SMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:12:06 -0400
Date: Tue, 27 May 2008 19:12:07 +0100
From: Ben Dooks <ben@fluff.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Ben Dooks <ben@fluff.org>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [spi-devel-general] Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080527181206.GB22585@trinity.fluff.org>
References: <4832A211.4040206@gmail.com> <20080527164415.GA27584@polina.dev.rtsoft.ru> <20080527165021.GA22585@trinity.fluff.org> <483C4C58.5080301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C4C58.5080301@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 07:00:56PM +0100, Jonathan Cameron wrote:
> 
> >
> > The two drivers i've seen so far use the input subsystem to report
> > their data to the user. I'm working on an driver for the SMB380 which
> > can be both i2c and spi.
> Yes, the ST accel I'm using (LIS3L02DQ) is like that as well, so we 
> definitely need
> to implement the ability to do this cleanly! 

this would be so much easier to read if word-wrapped to 77 characters
per line.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

