Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZKLBNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZKLBNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759885AbZKLBNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:13:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:60038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724AbZKLBNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:13:51 -0500
Date: Thu, 12 Nov 2009 02:13:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
In-Reply-To: <94a0d4530911111628p3edad1a0me3bb9f312491c637@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911120213380.15039@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>  <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>  <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>  <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com> 
 <alpine.LSU.2.00.0910191655220.8582@wotan.suse.de>  <94a0d4530910190815n4cf2c2ebmd288f6e7501b1ba5@mail.gmail.com>  <alpine.LSU.2.00.0910191716580.8582@wotan.suse.de>  <94a0d4530910190949y265426cbq4c32466a9fab8966@mail.gmail.com>  <alpine.LSU.2.00.0910200047200.8582@wotan.suse.de>
 <94a0d4530911111628p3edad1a0me3bb9f312491c637@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Felipe Contreras wrote:

> > Well at least older compilers were able to see this, only 4.4 seems to be
> > warning here ... I have applied the patch for now, but I am really not
> > fully convinced about it yet, we should probably report it to gcc folks
> > anyway.
> 
> I have in my to-do list to report this to the gcc guys, but in the
> meantime I don't see this patch applied.

It is applied in my tree, scheduled for next merge window.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
