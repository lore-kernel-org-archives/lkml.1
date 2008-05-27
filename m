Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYE0SBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYE0SBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYE0SBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:01:34 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:54394 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbYE0SBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:01:33 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <483C4C58.5080301@gmail.com>
Date: Tue, 27 May 2008 19:00:56 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Dooks <ben@fluff.org>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [spi-devel-general] Accelerometer, Gyros and ADC's etc within
 the kernel.
References: <4832A211.4040206@gmail.com> <20080527164415.GA27584@polina.dev.rtsoft.ru> <20080527165021.GA22585@trinity.fluff.org>
In-Reply-To: <20080527165021.GA22585@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> The two drivers i've seen so far use the input subsystem to report
> their data to the user. I'm working on an driver for the SMB380 which
> can be both i2c and spi.
Yes, the ST accel I'm using (LIS3L02DQ) is like that as well, so we 
definitely need
to implement the ability to do this cleanly! 

