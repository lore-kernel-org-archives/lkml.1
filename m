Return-Path: <linux-kernel-owner+w=401wt.eu-S937226AbXHOWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226AbXHOWoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936999AbXHOWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:43:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936724AbXHOWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:43:12 -0400
Date: Wed, 15 Aug 2007 15:42:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Message-Id: <20070815154245.500c572c.akpm@linux-foundation.org>
In-Reply-To: <1186990219.22431.37.camel@caritas-dev.intel.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 15:30:19 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> Interface) runtime services support to x86_64 architecture.

I had to rework these a bit due to clashes with
x86_64-add-acpi-reboot-option.patch.  Please check carefully that
everything landed OK.



