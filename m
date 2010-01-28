Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422Ab0A1AbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0A1AbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0A1AbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:31:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47203 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0A1AbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:31:08 -0500
Subject: Re: [PATCH] x86: add Dell OptiPlex 760 reboot quirk
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B60DA05.8020509@zytor.com>
References: <1264634958.27335.1091.camel@emiko> <4B60DA05.8020509@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 16:29:55 -0800
Message-ID: <1264638595.27335.1092.camel@emiko>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 16:27 -0800, H. Peter Anvin wrote:
> On 01/27/2010 03:29 PM, Leann Ogasawara wrote:
> > Hi All,
> > 
> > A bug reporter noted their Dell OptiPlex 760 hangs on reboot unless
> > reboot=bios is specified.  They have confirmed the following reboot
> > quirk resolves the issue.  Please consider applying for 2.6.33.
> > 
> 
> Could we find out if reboot=acpi works on this machine?

Sure, I'll ask the reporter to confirm.

Leann

