Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbYECKje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbYECKje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761726AbYECKjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:39:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761709AbYECKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sCITCB56nLEUPRpU581UfKGuwr/uhMBfAiWgVXqw36YsV0rQP2wg5/jvQZnSzO0upSJqbhwB9UXsqoc846VcNCzQ3CnniK6UmoX4O7ULKUbdt97NgzC2QUVff+ybLrmiOcnM+KbpvUqkwCM6onLBrLaDY71T/WfVW4Pt9IO7EAI=
Message-ID: <e2e108260805030339q4fcaedf7t34e737c14801e788@mail.gmail.com>
Date: Sat, 3 May 2008 12:39:19 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: SCSI target subsystem
Cc: "FUJITA Tomonori" <tomof@acm.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <20080503095314.GX14976@parisc-linux.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2008 at 11:53 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> Bart, what is your role in the SCST project?  You don't seem to have
> contributed any code to it (going by the SVN logs on sourceforge), and
> your questions and suggestions seem to be those of someone not familiar
> with the code.  If you're not a developer, it might be more helpful for
> you to step back and let Vladislav handle this.

I'd like to see this discussion focus on the technical issues. Why are
people constantly throwing up political arguments in this discussion ?

To answer your question: as you noticed, I did not yet contribute any
code to the SCST project. I'm an iSCSI/iSER/SRP user. I'd like to have
a SCSI target framework available on Linux that is as fast as
possible, as reliable as possible, as standards compliant as possible,
well maintained and for which all kernel code is integrated in the
mainstream Linux kernel. I'm probably sharing this desire with all
STGT, IET, SCST and LIO users. Do you consider the opinion of SCSI
target framework users irrelevant in this discussion ?

Bart.
