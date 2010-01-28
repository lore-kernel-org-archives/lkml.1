Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978Ab0A1A3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0A1A3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974Ab0A1A3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:29:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0A1A3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:29:06 -0500
Message-ID: <4B60DA05.8020509@zytor.com>
Date: Wed, 27 Jan 2010 16:27:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Leann Ogasawara <leann.ogasawara@canonical.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add Dell OptiPlex 760 reboot quirk
References: <1264634958.27335.1091.camel@emiko>
In-Reply-To: <1264634958.27335.1091.camel@emiko>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 03:29 PM, Leann Ogasawara wrote:
> Hi All,
> 
> A bug reporter noted their Dell OptiPlex 760 hangs on reboot unless
> reboot=bios is specified.  They have confirmed the following reboot
> quirk resolves the issue.  Please consider applying for 2.6.33.
> 

Could we find out if reboot=acpi works on this machine?

	-hpa
