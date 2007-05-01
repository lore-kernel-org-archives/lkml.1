Return-Path: <linux-kernel-owner+w=401wt.eu-S1031675AbXEALWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031675AbXEALWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031676AbXEALWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:22:13 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:47023 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031675AbXEALWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:22:12 -0400
Date: Tue, 1 May 2007 13:22:09 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070501112208.GD6895@gmail.com>
References: <fa.pO/RoNmzgLz6KNMO4Ste8iezOk8@ifi.uio.no> <46327F5D.4060708@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46327F5D.4060708@shaw.ca>
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:55:25PM -0600, Robert Hancock wrote:

>  Sounds like the cx88 driver is not using the DMA API properly to set up 
>  proper mappings, this will blow up if it tries to access memory above the 
>  4GB mark if the device cannot do >32bit DMA..

Any idea on how to solve this ?

Thank,
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
