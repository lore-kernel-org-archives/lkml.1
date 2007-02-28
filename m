Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXB1Qor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXB1Qor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbXB1Qor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:44:47 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:64440 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXB1Qoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:44:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GUYf6HT+2c3wWVVX5+2KhaT2rWIBbU+k11uVK9tkbYe1Wf1sa05zNIfpsEjB5kzJEw8ZdbwErTdUTxG4Pw91qt3ok1Na+wAXsXCwNHjBRL0v3Wp1kOOjuI9ORo5OoPvpTkiiJfkfAM4WpfEZ+TEbOPYuD3/C1nOAkyUpwgNgnnU=
Message-ID: <9c21eeae0702280844w7f490b1bx7945467bbd13b994@mail.gmail.com>
Date: Wed, 28 Feb 2007 08:44:45 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Linux 2.6.21-rc2
Cc: "Brice Goglin" <Brice.Goglin@ens-lyon.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1hct6ig2v.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <45E531AE.5050300@ens-lyon.org>
	 <m1hct6ig2v.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes. I goofed, and missed that stupid case.  The offending lines
> should just die.  Patch already sent to Linus.

Could the patch be posted? or could I see a git commit so I can get it myself?

Thanks,
David Brown
