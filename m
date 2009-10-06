Return-Path: <linux-kernel-owner+w=401wt.eu-S933436AbZJFWFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbZJFWFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZJFWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:05:41 -0400
Received: from claw.goop.org ([74.207.240.146]:42495 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302AbZJFWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:05:40 -0400
Message-ID: <4ACBBF0E.60603@goop.org>
Date: Tue, 06 Oct 2009 15:05:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: "Kay, Allen M" <allen.m.kay@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@sous-sol.org" <chris@sous-sol.org>
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com> <4ACBB8B0.9030102@goop.org> <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/09 15:01, Kay, Allen M wrote:
> Better move to somewhere arch independent as I'm calling this in architectural independent PCI driver code.
>   

I'm prepping a patch for you now, to move it to xen/xen.h.

    J

