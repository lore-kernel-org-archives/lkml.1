Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbXEQKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbXEQKMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXEQKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:12:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50124 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbXEQKMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:12:36 -0400
Date: Thu, 17 May 2007 15:42:19 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed update of the i386 boot document
Message-ID: <20070517101219.GE28280@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <464BABB2.5020104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464BABB2.5020104@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 06:11:14PM -0700, H. Peter Anvin wrote:
> I have noticed that a few items in the i386 boot document have become a
> bit incoherent and/or dated over the years.  Attached is an attempt at
> rewriting a few of the sections; the main things is a field-by-field
> description for the setup header.
> 
> I would appreciate comments as to if this makes it easier to follow or not.
> 

Overall looks good to me. Especially for relocatable kernel, to a boot
loader now it is more clear what is the meaning of different fields
and need to modify code32_start if protected mode kernel was loaded
at non 1MB address.

Thanks
Vivek

