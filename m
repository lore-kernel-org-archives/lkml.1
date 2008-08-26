Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYHZLDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYHZLDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYHZLDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:03:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:14526 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYHZLDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QutgI3z5aTgtZzHCqXYE/ImKm4DhzBZZ7KsD9wIC0h6JziSQQQ0u+4DFKPY7u332ga
         4a9zCldcVYceS4GdDpLrGEpLLmU4U7uLgZ52OUlhVRq2m0Nnm/NTQShvTS8BE0kgghky
         DTOmDEXBHTrVNbyssgYgfcTUjy+7gKRJqSo4c=
Message-ID: <ac9c93b10808260403ga9f6e13v4792bb2c13dfc2bf@mail.gmail.com>
Date: Tue, 26 Aug 2008 13:03:21 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [PATCH] x86: default to reboot via ACPI
Cc: "Pavel Machek" <pavel@suse.cz>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <48B3D579.40502@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	 <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/26 Avi Kivity <avi@qumranet.com>:

> It seems excessive.  Most machines will hardly run without acpi.

Well, I'm fairly sure that most of the systems running linux (or some
variant like uclinux), do not support acpi.

Linux is used a lot in embedded systems (like routers and NAS-es and
probably set-top boxes). I guess the # of embedded systems with some
linux flavour on it is substantially bigger than the desktop systems.
Most of these are ARM or MIPS based and do not support ACPI.

Frans.
