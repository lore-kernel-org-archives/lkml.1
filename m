Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZGOPJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZGOPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZGOPJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:09:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48959 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZGOPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:09:26 -0400
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: rohan a <info1686@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:09:23 +0000
Message-Id: <1247670563.4236.16.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
> Hi guys,
> 
> Any suggestions...please help

I know of no kernel bug that could be causing this.  The SLES9 kernel is
just too old though for me to remember clearly.  I'd suggest you file a
support incident with SUSE ... they'll debug and fix this on the older
kernels; we really only deal with the new kernel and one or two back
revisions here on linux-scsi.

James


