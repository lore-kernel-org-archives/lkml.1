Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab0BFOt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 09:49:29 -0500
Received: from poutre.nerim.net ([62.4.16.124]:56982 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0BFOt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 09:49:28 -0500
Date: Sat, 6 Feb 2010 15:49:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: Re: [RFC] Staging: IIO: New ABI V2
Message-ID: <20100206154924.46fa309d@hyperion.delvare>
In-Reply-To: <4B6D75C5.70404@cam.ac.uk>
References: <4B6C619C.3000302@cam.ac.uk>
	<20100205223224.GL5791@ovro.caltech.edu>
	<4B6D75C5.70404@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Feb 2010 13:59:33 +0000, Jonathan Cameron wrote:
> * The smbus alert stuff should work fine as an event source.  I remember seeing
>   some patches for support in i2c from David Brownell. We probably want to chase
>   these up for this device driver.

FWIW, I'm reworking David's patches right now and should have something
ready for public consumption by the end of tomorrow.

-- 
Jean Delvare
