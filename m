Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYCGKgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYCGKgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCGKga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:36:30 -0500
Received: from ns.firmix.at ([62.141.48.66]:1565 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbYCGKg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:36:29 -0500
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
From: Bernd Petrovitsch <bernd@firmix.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47D06265.8030305@zytor.com>
References: <200803060001.38432.paplociennik@gmail.com>
	 <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu>
	 <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>
	 <47D06265.8030305@zytor.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 07 Mar 2008 11:36:01 +0100
Message-Id: <1204886161.15966.17.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.331 required=5
X-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Don, 2008-03-06 at 13:30 -0800, H. Peter Anvin wrote:
> Pavel Machek wrote:
> > 
> > This really should be in kernel, I should not have to partition my
> > disk to get booting to few different distros.
> > 
> 
> Use a small initramfs.  That's the Right Thing to do in the first place.

... or use a statically linked chroot program (not necessarily to be
found in /working_distro). Shouldn't be too large anyways ....

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


