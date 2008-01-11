Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbYAKQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbYAKQwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbYAKQwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:52:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5004 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYAKQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:52:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VNYrV+Gtx+O/KsKr1Ngm3P8MJd9w7KPNiFqIKqvP+6TD6JaoCRXc9FJ3Iz0s/e/5rQEqerAnR0x8YeE6Z/DCJRbEzqcSSXQq7Z2XdT7Gmh0litQ9mIhYGFF7qoJga7eOfVbdrH8gvz5bA7seFlZ7oYl/OJi0okCzdB+cC6Usbag=
Message-ID: <47879EC1.5060508@gmail.com>
Date: Fri, 11 Jan 2008 17:52:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI Failed to allocate mem for PCI ROM
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <47872BC8.2040204@gmail.com> <0119CD93-D9F1-42E0-9F6A-A50B2C63B19D@kernel.crashing.org> <47873333.5020202@gmail.com> <FB6DCE73-5D8A-42AC-AE5C-0C1AD095B50B@kernel.crashing.org>
In-Reply-To: <FB6DCE73-5D8A-42AC-AE5C-0C1AD095B50B@kernel.crashing.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala napsal(a):
> I saw that patch, but if you notice that its just x86 specific and I'm
> having the issue on a powerpc 32-bit system.

My bad, sorry.
