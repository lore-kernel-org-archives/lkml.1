Return-Path: <linux-kernel-owner+w=401wt.eu-S934172AbZJNOyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbZJNOyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbZJNOyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:54:06 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:38075 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934172AbZJNOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=tTCkPkAOXWiZQokaZnxIu6FmnSL9wJTnte305wL2YFMnmjAWjDEKXCMXzs3BgZYjaF
         abLWOxast30fUPqspxDIMLeuGRMF6gj3MUt4i6GnTyDYO4cSrz5NnIlQsU9Nut5DAegC
         RzvPuw3praTklm4gCAlJzJFq/Vb2gTdaDl0uk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 16:52:40 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00279-g2ffa5fe; KDE/4.3.1; x86_64; ; )
Cc: Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <200910132357.57094.bzolnier@gmail.com> <20091014140923.GA2890@tuxdriver.com>
In-Reply-To: <20091014140923.GA2890@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200910141652.41041.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 16:09:24 John W. Linville wrote:
> On Tue, Oct 13, 2009 at 11:57:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > Several months later (after all current users are happy with the improved
> > drivers) the old drivers will be removed from staging..
> 
> I _really_ hope this isn't the standard.  By that measure, nothing
> will ever leave staging as _someone_ will always have some use case
> that makes the other driver better for them.

Doesn't seem to be the case with all other drivers except wireless ones
and the only real reason why wireless ones are so special is because of:

"But then there's the users, who bitch about everything and simply do
not understand what it is at stake.

And all this is becoming way too messy for us to handle.

Personally all I see around me is people bitching and complaining, and
no code being ported."

attitude which pretty much explains the problem..

Please adjust the process to fix the problem yourself or if you do not
want to do it just make the room for people who do.
