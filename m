Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYEDPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYEDPxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYEDPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:53:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:43748 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYEDPxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:53:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QFGM1c3OMuKt09TZRagZq+IBjUpl2iIq8s2/QNFCGdZkJ/Qy2TtLgBvHPRdnTZinK1NeSqh5zLpJFWLjqTzVL4Z0bnZTw4ROMUzbBOr9KJ5Nrw9q1igzNLu0HTf6Hg4hix2/HtvZQsXe8RVcwkgQ/wjW1rNq2HkG37vBEgwOp5s=
Message-ID: <e2e108260805040853r2dbd0b3bu297408c0c77819c5@mail.gmail.com>
Date: Sun, 4 May 2008 17:53:32 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: SCSI target subsystem
Cc: "FUJITA Tomonori" <tomof@acm.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
	 <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
	 <20080503095314.GX14976@parisc-linux.org>
	 <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 12:39 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> To answer your question: as you noticed, I did not yet contribute any
> code to the SCST project. I'm an iSCSI/iSER/SRP user. I'd like to have
> a SCSI target framework available on Linux that is as fast as
> possible, as reliable as possible, as standards compliant as possible,
> well maintained and for which all kernel code is integrated in the
> mainstream Linux kernel. I'm probably sharing this desire with all
> STGT, IET, SCST and LIO users.

Hello Matthew,

To be complete I should have mentioned that there already exists an
FCoE target implementation for SCST. I'm still learning about FCoE.
What I read about it is that FCoE has more to offer with regard to
storage management than iSCSI/iSER/SRP ?

See also: http://www.open-fcoe.org/openfc/wiki/index.php/Quickstart

Bart.
