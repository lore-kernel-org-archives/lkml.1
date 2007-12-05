Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXLELOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXLELOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 06:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXLELOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 06:14:06 -0500
Received: from mail.suse.de ([195.135.220.2]:43043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXLELOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 06:14:03 -0500
To: Amos Waterland <apw@us.ibm.com>
Cc: akpm@osdl.org, horms@verge.net.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Updates to nfsroot documentation (take 2)
From: Andi Kleen <andi@firstfloor.org>
References: <20071205045932.GA7160@us.ibm.com>
Date: Wed, 05 Dec 2007 12:14:00 +0100
In-Reply-To: <20071205045932.GA7160@us.ibm.com> (Amos Waterland's message of "Tue\, 4 Dec 2007 23\:59\:32 -0500")
Message-ID: <p73k5ntjsw7.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amos Waterland <apw@us.ibm.com> writes:

> The difference between ip=off and ip=::::::off has been a cause of much
> confusion.  Document how each behaves, and do not contradict ourselves
> by saying that "off" is the default when in fact "any" is the default
> and is descibed as being so lower in the file.

Perhaps also mention ip=dhcp there while you're at it. Right now
it is not mentioned, but it is the most important option.

-Andi
