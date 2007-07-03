Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbXGCLm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbXGCLm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXGCLmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:42:19 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:57964 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbXGCLmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:42:19 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 13:42:13 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707030944.18702.oliver@neukum.org> <18058.12724.163599.707035@cargo.ozlabs.ibm.com>
In-Reply-To: <18058.12724.163599.707035@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707031342.14295.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Paul Mackerras:
> I'm actually having a hard time thinking of how to test your assertion
> since there are so few things on a typical computer that are plain
> character devices driving real hardware.  A serial port would be about
> the only one; keyboards and mice (and serial ports :) are USB these
> days, or ADB on older powerbooks.

USB devices certainly have suspend methods.

	Regards
		Oliver

