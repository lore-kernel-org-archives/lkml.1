Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbYFWTvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbYFWTvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbYFWTu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:50:56 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60763 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429AbYFWTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:50:55 -0400
Date: Mon, 23 Jun 2008 15:50:54 -0400
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Forensic File System GUID Linux/Windows
Message-ID: <20080623195054.GA31126@csclub.uwaterloo.ca>
References: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 01:22:26PM -0600, jmerkey@wolfmountaingroup.com wrote:
> 
> The following GUID is being used in the Wolf Mountain Group, Inc. Forensic
> File System (FFS) for GPT intel EFI partitions.  Since there is no central
> registry for EFI GUID's it is posted here for referece for folks who may
> run accross it on Windows Vista, 2003, and 2008 systems running FFS on
> Windows that may be using dual boot with Linux or vmware:
> 
> #define PARTITION_FFS_GUID \
>     EFI_GUID( 0xBEEFCAFE, 0xFEED, 0x0000, \
>               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01)
> 
> 
> Patches to efi.h and efi.c in /fs/partitions will be posted after July 2,
> 2008 to www.wolfmountaingroup.org.

So how many 'FFS' filesystems does that make now?  Why not ForenFS or
something more unique?

-- 
Len Sorensen
