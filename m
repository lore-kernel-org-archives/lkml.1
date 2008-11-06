Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYKFVvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYKFVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYKFVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:50:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41579 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbYKFVuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:50:52 -0500
Date: Thu, 6 Nov 2008 21:50:11 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081106215011.GA6391@srcf.ucam.org>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <20081106143021.GD13023@elte.hu> <20081106150610.GA1644@elte.hu> <200811061853.08003.arvidjaar@mail.ru> <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811061442590.3106@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:50:06PM -0500, Len Brown wrote:

> My expectation is that with the ACPI default, our problem
> is working around a finite list of old machines that don't work;
> while with the default KBD, our problem is working around
> a potentially unbounded list of yet to be shipped machines
> who may only be tested and work using the ACPI method.

Does Windows default to using the ACPI method now?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
